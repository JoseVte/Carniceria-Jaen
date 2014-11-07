#para poder ejecutar el test desde RubyMine
$LOAD_PATH << File.expand_path('../..', __FILE__)

module Rack
  module Test
    class Session
      def rack_session
        @rack_session ||= {}
      end
      def rack_session=(hash)
        @rack_session = hash
      end
      def env_for(path, env)
        old_env_for(path, env).merge({'rack.session' => rack_session})
      end
    end
  end
end
