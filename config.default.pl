#########
# modify these values accordingly (and save file as "config.pl")
#########
# should the graphs be removed on each run
# (set to 1 to enable removing graphs before creation)
# defaults to 0 (update, don't remove); update is better because it preserves ids
$config_recreate_graphs = 0;

# user
$user = "Admin";
# password
$password = "zabbix";
# only add graphs to hosts linked to this template
$template = "AutoTomcatGraphs";
# internal
$header = "Content-Type:application/json";
# intenal zabbix url
$url = "http://127.0.0.1:8081/zabbix/api_jsonrpc.php";
# create a graph with this name in each host
$graph = 'Active Sessions auto-stack';
$graphtype = 1; ### 0=normal, 1=stacked
$mintype = 1; ### 0=calculated, 1=fixed
$maxtype = 0; ### 0=calculated, 1=fixed
$minvalue = 0;
$maxvalue = 100;
$showtriggers = 1;
$drawtype = 0; ### 0=line, 1=filled, 2=boldline, 3=dot, 4=dashed, 5=gradient
$calcfunction = 2; ### 1=min, 4=max, 2=avg, 7=all
# add graph items mathing these regexes, maximum 2
$regexes[0] = '^activeSessions\s.*';
#$regexes[1] = '^WIN\sVolume\s".*"\sbytes/sec\sread';
