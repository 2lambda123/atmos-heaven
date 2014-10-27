module Heaven
  module Jobs
    class EnvironmentLock
      @queue = :locks

      def self.perform(lock_params)
        locker = EnvironmentLocker.new(lock_params)
        locker.lock!

        status = ::Deployment::Status.new(lock_params[:name_with_owner], lock_params[:deployment_id])
        status.description = "#{locker.name_with_owner} locked on #{locker.environment} by #{locker.actor}"

        status.success!
      end
    end
  end
end