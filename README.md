Automatic graph for auto-discovered items
=========================================

Originally created by **mmarkwitzz**.
See: [https://www.zabbix.com/forum/zabbix-cookbook/27037-automatic-graph-of-all-lld-items-per-host](https://www.zabbix.com/forum/zabbix-cookbook/27037-automatic-graph-of-all-lld-items-per-host).

License: [CC-BY](https://creativecommons.org/licenses/by/3.0/). That basically means you are free to:
* Share — copy and redistribute the material in any medium or format.
* Adapt — remix, transform, and build upon the material for any purpose, even commercially.
  

What does this do?
------------------

The script creates a graph for automatically discovered items (LLD). For example you have applications on Tomcat server and you want to get a graph with a summary of all active sessions.

So for Tomcat sessions you might have item prototype "activeSessions {#JMXCONTEXT}". And now for your server you can have generated (discovered) items like:

* "activeSessions /manager"
* "activeSessions /"
* "activeSessions /myapp##123"

The problem is "##123" changes with version of your app. You also want to automatically add any new apps to the graph. The script does just that. It generates a graph with all items stacked on each other. So effectively you get a graph of all active sessions.

See some examples on the forum:
[https://www.zabbix.com/forum/zabbix-cookbook/27037-automatic-graph-of-all-lld-items-per-host](https://www.zabbix.com/forum/zabbix-cookbook/27037-automatic-graph-of-all-lld-items-per-host)

How to use?
-----------

First you will need to create the items. 

1. Create a Zabbix template with some name (e.g. "AutoTomcatGraphs"). Note that the template can be empty or it can contain your auto-discovery configuration or whatever. Technically the script only uses this for filtering hosts.
2. Add your template to hosts where you want to create graphs.
2. Download `*.pl` scripts and put them somewhere on your Zabbix server.
2. Install JSON for Perl (you don't have one already).
	* `sudo apt-get install make`
	* `sudo apt-get install cpanminus`
	* `sudo cpanm JSON`
2. Modify `config.default.pl` and save file as `config.pl`.
2. Run main script: `perl ./lld_all_graph.pl`.

Main things you need to change in configuration: 
* `$password` -- your Admin password.
* `$template` -- your template for filtering hosts (e.g. "AutoTomcatGraphs").
* `$graph` -- name for the graph. Note that the name must be unique. Graphs that already exist with that name **will be replaced**!
* `$regexes[0]` -- this is a regular expression to match items for the graph. Just replace macros in you items with `.+` and you should be fine. E.g. for `activeSessions {#JMXCONTEXT}` the regexp can be `'activeSessions .+'`. If you want to be a bit more strict you might want to make sure you match the begging of the name (e.g. `'^activeSessions .*'`).

Note! After testing your script you should run it automatically e.g. via `cron` or some other mechanism (like Jenkins). You can run this daily or weekly depending on your needs (depending on how often items change).

Resolving problems
------------------

Note that `$url` in the config is a url for Zabbix API (see [documentation on the API](https://www.zabbix.com/documentation/4.0/manual/api)). The script contains some diagnostic routines and should show you some information if your URL or password is incorrect. 

Also note that if `$regexes` is incorrect then the script will run, but will not create any graphs. In other words if no items are found then you will only see a list of matched hosts.

Upon success you should see something like:
```
HOSTGROUP: Hypervisors (7)
HOSTGROUP: Linux servers (2)
   HOST: myserver (123)
      ITEM: activeSessions / (12301)
      ITEM: activeSessions /manager (12302)
      ITEM: activeSessions /myapp##123 (12303)
         Graph created: Active Sessions auto-stack (12)
HOSTGROUP: Templates/Applications (12)
HOSTGROUP: Templates/Databases (13)
```
You will see "Graph updated" (instead of "Graph created") on next run.

Note that numbers in parentheses are ids of matched items/graphs etc.
