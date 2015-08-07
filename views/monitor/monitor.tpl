<body>

<div id="tt" class="easyui-tabs" style="width:1200px;height:800px;">
    <div title="Act Summary" style="padding:20px;">
        <div>
            <span>
                <input class="easyui-combobox" id="adunitList" name="adunitId"
                       data-options="valueField:'campaignId',textField:'campaignName'">
            </span>
            <span>
            <input class="easyui-datetimebox" id="startDate" style="width:150px">
            </span>
            <span>
            <input class="easyui-datetimebox" id="endDate" style="width:150px">
            </span>
            <span>
                <a id="btn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
            </span>

        </div>
        <div>
            <table id="dg"></table>
        </div>
    </div>
    <div title="Search" data-options="closable:false" style="overflow:auto;padding:20px;">

        <input id="ss" class="easyui-searchbox" style="width:300px"
               data-options="searcher:qq,prompt:'Please Input value',menu:'#mm'"></input>

        <div id="mm" style="width:120px">
            <div data-options="name:'guid'">guid</div>
            <div data-options="name:'offerId'">offerId</div>
        </div>

        <div id="result">

        </div>

    </div>
    <div title="S2s Log" data-options="iconCls:'icon-reload',closable:true" style="">
        <div class="query">
                <span>
                    <input class="easyui-combobox" id="s2s_adunitList" name="s2s_adunitId"
                           data-options="valueField:'campaignId',textField:'campaignName'">
                </span>
                <span>
                    <input class="easyui-datetimebox" id="s2s_startDate" style="width:150px">
                </span>
                <span>
                    <input class="easyui-datetimebox" id="s2s_endDate" style="width:150px">
                </span>
                <span>
                    <a id="s2s_btn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
                </span>
        </div>
        <div class="grid-result">
            <table id="s2s_dg"></table>
        </div>
    </div>

    <div title="Tracking event" data-options="iconCls:'icon-reload',closable:true" style="">
        <div class="query">
                <span>
                    <input class="easyui-datetimebox" id="event_startDate" style="width:150px">
                </span>
                <span>
                    <input class="easyui-datetimebox" id="event_endDate" style="width:150px">
                </span>
                <span>
                    <a id="event_btn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
                </span>
        </div>
        <div class="grid-result">
            <table id="event_dg"></table>
        </div>
    </div>

</div>


</body>
<script type="text/javascript">

    function qq(value, name) {

        if (name == "guid") {
            $.ajax({
                url: 'Install/CheckDeviceState',
                type: 'POST',
                data: {
                    guid: value
                },
                success: function (data) {
                    $("#result").text(JSON.stringify(data))
                }
            })
        } else {
            $.ajax({
                url: 'Adunit/QueryAdunit',
                type: 'POST',
                data: {
                    offerId: value
                },
                success: function (data) {
                    $("#result").text(JSON.stringify(data))
                }
            })
        }
    }

    function renderSummary() {
        $('#adunitList').combobox({
            url: 'Adunit/GetAll',
            valueField: 'campaignId',
            textField: 'campaignName'
        });

        var now = new Date()
        $('#startDate').datetimebox({
            value: new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000).format()
        });
        $('#endDate').datetimebox({
            value: now.format()
        });

        $('#btn').bind('click', function () {
            $('#dg').datagrid('load', {
                startDate: $('#startDate').datetimebox('getValue'),
                endDate: $('#endDate').datetimebox('getValue'),
                campaignId: $("input[name='adunitId']").val()

            })
        });

        $('#dg').datagrid({
            url: 'Adunit/QueryCampaign',
            columns: [[
                {field: 'CampaignId', title: 'Offer ID', width: 300},
                {field: 'CampaignName', title: 'Campaign Name', width: 300},
                {field: 'ReceivedCount', title: 'Received Installs', width: 120, align: 'right'},
                {field: 'PostbackCount', title: 'Postback Installs', width: 120, align: 'right'}
            ]]
        });

    }

    function renderEvent() {

        var now = new Date()
        $('#event_startDate').datetimebox({
            value: new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000).format()
        });
        $('#event_endDate').datetimebox({
            value: now.format()
        });

        $('#event_btn').bind('click', function () {

            $.ajax({
                url: 'Tracking/QueryEvent',
                type: 'POST',
                data: {
                    startDate: $('#event_startDate').datetimebox('getValue'),
                    endDate: $('#event_endDate').datetimebox('getValue'),
                },
                success: function (data) {
                    if (data.rows) {
                        $('#event_dg').datagrid('loadData', data);
                    } else {
                        $('#event_dg').datagrid('loadData', {total: 0, rows: {}});
                    }
                }
            })

        });

        $('#event_dg').datagrid({
            columns: [[
                {field: 'UtcDate', title: 'UtcDate', width: 300},
                {field: 'SessionId', title: 'SessionId', width: 300},
                {field: 'Action', title: 'Action', width: 120, align: 'right'},
                {field: 'Label', title: 'Label', width: 120, align: 'right'},
                {field: 'Value', title: 'Value', width: 120, align: 'right'},
                {field: 'CreateDate', title: 'CreateDate', width: 120, align: 'right'}
            ]]
        });

    }

    function renderSearch () {


    }

    function renderS2sLog () {

        var now = new Date()
        $('#s2s_startDate').datetimebox({
            value: new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000).format()
        });
        $('#s2s_endDate').datetimebox({
            value: now.format()
        });

        $('#s2s_adunitList').combobox({
            url: 'Adunit/GetAll',
            valueField: 'campaignId',
            textField: 'campaignName'
        });

        $('#s2s_dg').datagrid({
            columns: [[
                {field: 'OfferId', title: 'Offer id', width: 120, align: 'left'},
                {field: 'Guid', title: 'Guid', width: 300},
                {field: 'DeviceId', title: 'URL', width: 600},
            ]]
        });

        $('#s2s_btn').bind('click', function () {

            $.ajax({
                url: 'S2sActiveLog/SearchS2sLog',
                type: 'POST',
                data: {
                    startDate: $('#s2s_startDate').datetimebox('getValue'),
                    endDate: $('#s2s_endDate').datetimebox('getValue'),
                    campaignId: $("input[name='s2s_adunitId']").val()
                },
                success: function (data) {
                    if (data.rows) {
                        $('#s2s_dg').datagrid('loadData', data);
                    } else {
                        $('#s2s_dg').datagrid('loadData', {total: 0, rows: {}});
                    }
                }
            })



        });

    }

    $(function () {
        renderSummary();

        renderSearch();

        renderS2sLog();

        renderEvent();
    });
</script>