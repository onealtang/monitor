{{template "../public/header.tpl"}}
<script type="text/javascript">
var URL="/security"
    $( function() {
        //修改配色方案
        $("#changetheme").change(function(){
            var theme = $(this).val();
            $.cookie("theme",theme); //新建cookie
            location.reload();
        });
        //设置已选theme的值
//        var themed = $.cookie('theme');
//        if(themed){
//            $("#changetheme").val(themed);
//        }
    });
    function modifypassword(){
        $("#dialog").dialog({
            modal:true,
            title:"修改密码",
            width:400,
            height:250,
            buttons:[{
                text:'保存',
                iconCls:'icon-save',
                handler:function(){
                    $("#form1").form('submit',{
                        url:URL + '/changepwd',
                        onSubmit:function(){
                            return $("#form1").form('validate');
                        },
                        success:function(r){
                            var r = $.parseJSON( r );
                            if(r.status){
                                $.messager.alert("提示", r.info,'info',function(){
                                    location.href = URL+"/logout";
                                });
                            }else{
                                vac.alert(r.info);
                            }
                        }
                    });
                }
            },{
                text:'取消',
                iconCls:'icon-cancel',
                handler:function(){
                    $("#dialog").dialog("close");
                }
            }]
        });
    }
    //选择分组
    function selectgroup(group_id){
        $(this).addClass("current");
        vac.ajax(URL+'/index', {group_id:group_id}, 'GET', function(data){
            $("#tree").tree("loadData",data)
        })

    }
</script>

<style>
.ht_nav {
    float: left;
    overflow: hidden;
    padding: 0 0 0 10px;
    margin: 0;
}
.ht_nav li{
    font:700 16px/2.5 'microsoft yahei';
    float: left;
    list-style-type: none;
    margin-right: 10px;

}
.ht_nav li a{
    text-decoration: none;
    color:#333;
}
.ht_nav li a.current, .ht_nav li a:hover{
    color:#F20;

}
</style>
<body class="easyui-layout" style="text-align:left">
<div region="north" border="false" style="overflow: hidden; width: 100%; height:82px; background:#D9E5FD;">
    <div style="overflow: hidden; width:200px; padding:2px 0 0 5px;">
        <h2>PerforMAD Admin</h2>
    </div>
    <div id="header-inner" style="float:right; overflow:hidden; height:80px; width:300px; line-height:25px; text-align:right; padding-right:20px;margin-top:-50px; ">
        欢迎你！ {{.userinfo.Username}} <a href="javascript:void(0);" onclick="modifypassword()"> 修改密码</a>
        <a href="/public/logout" target="_parent"> 退 出</a>
    </div>
</div>
<div id="dialog" >
    <div style="padding:20px 20px 40px 80px;" >
        <form id="form1" method="post">
            <table>
                <tr>
                    <td>旧密码</td>
                    <td><input type="password"  name="oldpassword" class="easyui-validatebox"  required="true" validType="password[5,20]" missingMessage="请填写当前使用的密码"/></td>
                </tr>
                <tr>
                    <td>新密码：</td>
                    <td><input type="password"  name="newpassword" class="easyui-validatebox" required="true" validType="password[5,20]" missingMessage="请填写需要修改的密码"  /></td>
                </tr>
                <tr>
                    <td>重复密码：</td>
                    <td><input type="password"  name="repeatpassword"  class="easyui-validatebox" required="true" validType="password[5,20]" missingMessage="请重复填写需要修改的密码" /></td>
                </tr>
            </table>
        </form>
    </div>
</div>
</div>


<div region="center" border="false" >
    <div id="tabs" >
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
    </div>
</div>
</body>
</html>