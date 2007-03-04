class ConfigReader
  def self.config
    @config = nil unless defined?(@config)
    @config
  end

  def self.config=(new_config)
    @config = new_config
  end

  def self.reload
    raise 'No CONFIG_FILE set' unless defined?(self::CONFIG_FILE)
    conf = HashWithIndifferentAccess.new(YAML.load(
      ERB.new(File.open(File.join(
        RAILS_ROOT, 'config', self::CONFIG_FILE)).read
      ).result))

    self.config = conf[:defaults]
    self.config.merge!(conf[RAILS_ENV]) if RAILS_ENV && conf[RAILS_ENV]
    self.config
  end

  def self.[](key)
    self.config ||= self.reload
    self.config[key]
  end
end
