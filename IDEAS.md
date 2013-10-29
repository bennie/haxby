* Make python module to auto-discover haxby
* Add modes/flags to manage only the database within a running postgres
    * Would allow for multiple projects on shared instance without confusion
    * Would require using DROP DATABASE to ensure total wipe
* A useful `help` mode would be a major plus
    * List modes one per line, with a brief explanation
    * Per-mode detailed help
    * And perhaps a man page too!
    * Trigger help mode if `haxby` is run with no arguments
* Should be able to apply its configs to a real DB instance, for deployment
    * Then we are really cooking!
* More ways to do config autodiscovery
    * And a flag to specify the exact file
* Don't create pg folder unless necessary
* New Mode: Schema
    * Shows Numbered interface to allow editing of schema files
    * i.e: type '1', opens first schema file in $EDITOR
* Add mode to talk to Heroku db instances

* Include WAL-E so haxby can be run in a "production" style fashion
    * Add installation mode for daemontools, wal-e
    * Setup wal-e
