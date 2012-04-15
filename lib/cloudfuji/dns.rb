module Cloudfuji
  # Cloudfuji::App provides all of the methods to interact with the app it's included in,
  # and only contains class methods. Each method will check for the most recent data,
  # so it's possible the data may change between two separate calls.
  class App
    class << self
      def app_url #:nodoc:
        "#{Cloudfuji::Platform.host}/apps/#{Cloudfuji::Platform.name}.json"
      end


      def get(params={}) #:nodoc:
        Cloudfuji::Command.get_command(app_url, params)
      end


      def put(command, params={})  #:nodoc:
        params[:command] = command

        Cloudfuji::Command.put_command(app_url, params)
      end


      # Get all of the information related to the current app, returns a hash
      def show
        result = get
      end


      # Starts a currently stopped app
      # ==== Example Scenario
      # You may want to use this when recieving a \<tt>rake cloudfuji:message</tt> event to
      # start up your app for an incoming message
      def start
        put :start
      end


      # Stops an app.
      # ==== Example Scenario
      # Use this if you want to put your application in 'maintenance mode'.
      def stop
        put :stop
      end


      # Stops (if started) and then starts an app
      # ==== Example Scenario
      # if you've added environmental variables to an application and need the app
      # to restart to pick them up, use this.
      def restart # :nodoc:
        put :restart
      end

      # Claims an app for the current Cloudfuji user
      # Raises an exception if app is launched anonymously
      # ==== Example Scenario
      # Integrate Cloudfuji app claiming behavior directly into your app to help
      # conversion rates
      def claim
        put :claim
      end


      # Updates the app to the latest git checkout, using the branch the app
      # was initially dpeloyed from
      # ==== Example Scenario
      # Allow your users to upgrade to the latest version via a link directly in your application
      def update
        put :update
      end


      # Add an environmental variable
      # ==== Example Scenario
      # Allows your app to easily integrate into third-party services, e.g. mixpanel.
      # A user can enter their own API key, and you can activate your mixpanel code.
      def add_var(key, value)
        put :add_var, {:key => key, :value => value}
        if Cloudfuji::Command.last_command_successful?
          ENV[key.upcase] = value
        end
      end


      # Remove an environmental variable
      # ==== Example Scenario
      # 
      def remove_var(key)
        put :remove_var, {:key => key}
        if Cloudfuji::Command.last_command_successful?
          ENV[key.upcase] = nil
        end
      end


      # List all custom domains belonging to the current application
      # ==== Example Scenario
      # A CMS may want to use this if hosting multiple sites
      def domains
        get()["app"]["domains"]
      end


      # Returns the current subdomain of the app, whether that's the default
      # (e.g. "happy-rabbit-12") or a custom-set subdomain ("my-example")
      # ==== Example Scenario
      # A CMS will use this to know which subdomain to respond to
      def subdomain
        get()["app"]["subdomain"]
      end


      # Check if a subdomain of cloudfuji.com is currently available
      # ==== Example Scenario
      # An application may want to change its subdomain to something user-chosen;
      # use this before-hand to ensure it's available
      def subdomain_available?(subdomain)
        begin
          return put :subdomain_available?, {:subdomain => subdomain}
        rescue RestClient::UnprocessableEntity
          return false
        end
      end


      # Set the cloudfuji.com subdomain of an application
      # ==== Example Scenario
      # An app is initially launched to a randomly-generated subdomain, but may
      # want to move to something more memorable for a given user.
      def set_subdomain(subdomain)
        result = put :set_subdomain!, {:subdomain => subdomain}
        if Cloudfuji::Command.last_command_successful?
          ENV["CLOUDFUJI_SUBDOMAIN"] = subdomain
          ENV["PUBLIC_URL"] = "http://#{subdomain}.#{ENV['APP_TLD']}/"
          return result
        end

        result
      end


      # Adds a domain to the Cloudfuji webrecords for an app. The app \<b>must</b>
      # be a premium-app in order to add domains
      # ==== Example Scenario
      # If after launching a CMS a user decides to use a custom domain, an app
      # can allow a user to customize it directly without resorting to the Cloudfuji
      # app control panel.
      def add_domain(domain)
        put :add_domain!, {:domain => domain}
      end


      # Removes a custom domain from the Cloudfuji webrecords. Only works if the
      # custom domain:
      # * belongs to the current user
      # * points at the current app
      # ==== Example Scenario
      # A user may decide to migrate a domain to a different app. This allows an app
      # to remove it from its records without resorting to the Cloudfuji app
      # control panel
      def remove_domain(domain)
        put :remove_domain!, {:domain => domain}
      end


      # Clear out the given log
      # ==== Example Scenario
      # An app may keep its production log for analysis by the end-user, but the
      # user may want to clear out the irrelevant past logs.
      def clear_log!(name)
        put :clear_log!, {:name => name}
      end


      # Get all of the new logs. Returns a hash of the form {:name_of_log_X => "content of log X"}
      # On Cloudfuji, there are by default the following logs:
      # * access - Any page hit or asset request
      # * error - Any error we had serving the page/asset
      # * production - Output from the rails server
      # * cloudfuji - logs from the cloudfuji deploy, update, start/stop process
      #--
      # TODO: Update to use the new logs controller
      #++
      def logs
        get({:gift => "logs"})
      end


      def ssh_key #:nodoc:
        get({:gift => "ssh_key"})["ssh_key"]
      end
    end
  end
end
