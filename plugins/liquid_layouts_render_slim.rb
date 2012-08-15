module Jekyll


  class Layout
    def initialize(site, base, name)
      @site = site
      @base = base
      @name = name

      self.data = {}

      self.process(name)
      self.read_yaml(base, name)
      #This allows slim templates in the layouts dir, or others like
      #haml if the converter is in the plugins dir
      self.transform
      self.data
    end
  end

end
