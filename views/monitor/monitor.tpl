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
    <div title="Tab3" data-options="iconCls:'icon-reload',closable:true" style="">
    </div>
</div>


</body>
<script type="text/javascript">

    function qq(value, name){
//        alert(value+":"+name)

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


    $(function () {
        $('#adunitList').combobox({
            url: 'Adunit/GetAll',
            valueField: 'campaignId',
            textField: 'campaignName'
        });

        $('#btn').bind('click', function () {
            $('#dg').datagrid('load', {
                startDate: $('#startDate').datetimebox('getValue'),
                endDate: $('#endDate').datetimebox('getValue'),
                campaignId: $("input[name='adunitId']").val()

            })
        });

        var now = new Date()
        $('#startDate').datetimebox({
            value: new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000).format()
        });
        $('#endDate').datetimebox({
            value: now.format()
        });

        $('#dg').datagrid({
            url: 'Adunit/QueryCampaign',
            columns: [[
                {field: 'campaignId', title: 'Offer ID', width: 300},
                {field: 'campaignName', title: 'Campaign Name', width: 300},
                {field: 'receivedCount', title: 'Received Installs', width: 120, align: 'right'},
                {field: 'postbackCount', title: 'Postback Installs', width: 120, align: 'right'}
            ]]
        });


    })
</script>