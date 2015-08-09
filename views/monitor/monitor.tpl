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
            <table id="dg" style="height: 600px;" data-options="
                rownumbers:true,
                singleSelect:true,
                autoRowHeight:false,
                pagination:true,
                pageSize:20"></table>
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
    <div title="S2s Log" style="">
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
            <table id="s2s_dg" style="height: 600px;" data-options="
                rownumbers:true,
                singleSelect:true,
                autoRowHeight:false,
                pagination:true,
                pageSize:20"></table>
        </div>
    </div>

    <div title="Tracking event" style="">
        <div class="query">
                <span>
                    <input class="easyui-textbox" data-options="prompt:'Conversion ID'" id="event_cvid" style="width: 150px;height:32px">
                </span>
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
            <table id="event_dg" style="height: 600px;"
                   data-options="
                    rownumbers:true,
                    singleSelect:true,
                    autoRowHeight:false,
                    pagination:true,
                    pageSize:20">
                <thead>
                    <th field="CreateDate" width="120">CreateDate</th>
                    <th field="UtcDate" width="120">UtcDate</th>
                    <th field="ConversionId" width="120">ConversionId</th>
                    <th field="SessionId" width="120">SessionId</th>
                    <th field="Guid" width="120">Guid</th>
                    <th field="Action" width="120">Action</th>
                    <th field="Label" width="120">Label</th>
                    <th field="Value" width="120">Value</th>
                </thead>
            </table>
        </div>
    </div>

</div>


</body>
<script type="text/javascript">

    (function($){
        function pagerFilter(data){
            if ($.isArray(data)){	// is array
                data = {
                    total: data.length,
                    rows: data
                }
            }
            var dg = $(this);
            var state = dg.data('datagrid');
            var opts = dg.datagrid('options');
            if (!state.allRows){
                state.allRows = (data.rows);
            }
            var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
            var end = start + parseInt(opts.pageSize);
            data.rows = $.extend(true,[],state.allRows.slice(start, end));
            return data;
        }

        var loadDataMethod = $.fn.datagrid.methods.loadData;
        $.extend($.fn.datagrid.methods, {
            clientPaging: function(jq){
                return jq.each(function(){
                    var dg = $(this);
                    var state = dg.data('datagrid');
                    var opts = state.options;
                    opts.loadFilter = pagerFilter;
                    var onBeforeLoad = opts.onBeforeLoad;
                    opts.onBeforeLoad = function(param){
                        state.allRows = null;
                        return onBeforeLoad.call(this, param);
                    }
                    dg.datagrid('getPager').pagination({
                        onSelectPage:function(pageNum, pageSize){
                            opts.pageNumber = pageNum;
                            opts.pageSize = pageSize;
                            $(this).pagination('refresh',{
                                pageNumber:pageNum,
                                pageSize:pageSize
                            });
                            dg.datagrid('loadData',state.allRows);
                        }
                    });
                    $(this).datagrid('loadData', state.data);
                    if (opts.url){
                        $(this).datagrid('reload');
                    }
                });
            },
            loadData: function(jq, data){
                jq.each(function(){
                    $(this).data('datagrid').allRows = null;
                });
                return loadDataMethod.call($.fn.datagrid.methods, jq, data);
            },
            getAllRows: function(jq){
                return jq.data('datagrid').allRows;
            }
        })
    })(jQuery);


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

            });
        });

        $('#dg').datagrid({
            url: 'Adunit/QueryCampaign',
            columns: [[
                {field: 'CampaignId', title: 'Offer ID', width: 300},
                {field: 'CampaignName', title: 'Campaign Name', width: 300},
                {field: 'ReceivedCount', title: 'Received Installs', width: 120, align: 'right'},
                {field: 'PostbackCount', title: 'Postback Installs', width: 120, align: 'right'}
            ]]
        }).datagrid('clientPaging');

    }

    function renderEvent() {

        var now = new Date()
        $('#event_startDate').datetimebox({
            value: new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000).format()
        });
        $('#event_endDate').datetimebox({
            value: now.format()
        });

        $('#event_dg').datagrid({data: null}).datagrid('clientPaging');

        $('#event_btn').bind('click', function () {

            $.ajax({
                url: 'Tracking/QueryEvent',
                type: 'POST',
                data: {
                    conversionId: $('#event_cvid').val(),
                    startDate: $('#event_startDate').datetimebox('getValue'),
                    endDate: $('#event_endDate').datetimebox('getValue')
                },
                success: function (data) {
                    if (data.rows) {
                        $('#event_dg').datagrid('loadData', data);
                    } else {
                        $('#event_dg').datagrid({data:{total: 0, rows: {}}});
                    }
                }
            })

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
                {field: 'Guid', title: 'Guid', width: 120},
                {field: 'DeviceId', title: 'URL', width: 1000},
            ]]
        }).datagrid('clientPaging');

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