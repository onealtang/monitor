<html>
<head>
    <title>PerforMad Admin</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <link rel="stylesheet" type="text/css" href="/static/easyui/jquery-easyui/themes/default/easyui.css" />
    <link rel="stylesheet" type="text/css" href="/static/easyui/jquery-easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="/static/css/monitor.css" />
    <script type="text/javascript" src="/static/easyui/jquery-easyui/jquery.min.js"></script>
    <script type="text/javascript" src="/static/easyui/jquery-easyui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="/static/easyui/jquery-easyui/common.js"></script>
    <script type="text/javascript" src="/static/easyui/jquery-easyui/easyui_expand.js"></script>
    <script type="text/javascript" src="/static/easyui/jquery-easyui/phpjs-min.js"></script>
    <script type="text/javascript" src="/static/admin/common.js"></script>
</head>
<body>

<div class="container">
    <body>
    <div id="tt" class="easyui-tabs" style="width:1200px;height:800px;">

        <div title="Events" style="">
            {{ .Tracking_Event }}
        </div>

        <div title="S2s Log" style="">
            {{ .S2s_Activelog }}
        </div>

        <div title="Search" data-options="closable:false" style="overflow:auto;padding:20px;">

            {{ .Entity_Search }}

        </div>

        <!--<div title="Act Summary" style="padding:20px;">-->
            <!--{{ .Act_Summary }}-->
        <!--</div>-->

    </div>
    </body>
</div>
</body>
</html>