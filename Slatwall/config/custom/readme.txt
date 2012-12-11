This Custom directory is designed to be used for per-install settings and customizations of Slatwall.  During updates it will never be deleted so any changes within this directory are safe from update (as long as you use the updater in the slatwall admin).


- /config/custom/coldspring.xml | If you create this file, you are able to fully take control of the underlying coldspring config.  This allows for you to pick select beans and map them to a new component that extends the original file

- /config/custom/resourceBundles | Any resource bundles added here will have their keys override the keys in the core resource bundle

- /config/custom/settings.ini.cfm | This file allows for custom settings like app-reload key

- /config/custom/key.xml.cfm | This file is the default encryption key that gets created