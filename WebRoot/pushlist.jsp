﻿<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="bean.Admin"%>
<%@ page import="bean.Push"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%
	String path 	= 	request.getContextPath();
	String basePath =	request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
    List<Push> list= 	(List<Push>)request.getAttribute("list");
    String keyword	=	(String)request.getAttribute("keyword");  //一共多少记录
    int totalPage 	=   (Integer)request.getAttribute("totalPage");  //一共多少页
    int totalRecord =   (Integer)request.getAttribute("totalRecord");  //一共多少记录
    int firstPage 	=  	(Integer)request.getAttribute("firstPage"); //当前页
    int currentPage =  	(Integer)request.getAttribute("currentPage"); //当前页
    int lastPage	=	(Integer)request.getAttribute("lastPage");  //一共多少记录
    int PAGE_SIZE	=	(Integer)request.getAttribute("PAGE_SIZE");  //一共多少记录
    Object user		=	session.getAttribute("user");
    if(user==null){
        response.getWriter().println("<script>top.location.href='" + basePath + "push/push_doLogin.action';</script>");
    }
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml">
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=yes" />

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>信息推送列表</title>


<link href="<%=basePath%>css/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=basePath%>js/jquery.js"></script>


<script type="text/javascript">
	function checkDelete() {
		return confirm("确定要删除？");
	}
</script>


<script type="text/javascript">
	function edit() {
		var check = document.getElementsByName("check");
		var len = check.length;
		var editid = 0;
		var flag=0;
		for (var i = 0; i < len; i++) {
			if (check[i].checked) {
				editid= check[i].value;
				flag++;
			}
		}
 		if(flag==0){
 			window.alert("请选择要修改的对象");
		}else if(flag==1){
			if(confirm("确定要修改？")){
 				window.location.href="<%=basePath%>push/push_doEdit.action?push.pushId="+editid;
			}
		}
 		else{
 			window.alert("一次只能修改一个对象");
		}
	}
</script>


<script type="text/javascript">
	function deleteAll() {
		var check = document.getElementsByName("check");
		var len = check.length;
		var deletelist = "";
		for (var i = 0; i < len; i++) {
			if (check[i].checked) {
				deletelist += check[i].value + ",";
			}
		}
 		if(deletelist==""){
 			window.alert("请选择要删除的对象？");
		}
 		else{
 			if(confirm("确定要删除？")){
 				window.location.href="<%=basePath%>push/push_doDeleteAll.action?deletelist="+deletelist+"&currentPage=<%=currentPage%>
	";
			}
		}
	}
</script>



<script language="JavaScript" type="text/javascript">
	var flag = 1;
	function selectAll() {
		var check = document.getElementsByName("check");
		if (flag == 1) {
			for (var i = 0; i < check.length; i++)
				check[i].checked = true;
			flag = 0;
		} else {
			for (var i = 0; i < check.length; i++)
				check[i].checked = false;
			flag = 1;
		}
	}
</script>


</head>

<body>
	<form action="<%=basePath%>push/push_doFind.action" name="pushlistForm" id="pushlistForm" method="post">
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
			<li1><a href="<%=basePath%>mainindex.jsp">首页</a></li1>
				<li1><a href="<%=basePath%>push.jsp">推送查找</a></li1>
				<li1><a  style="color:blue;" href="<%=basePath%>push/push_doFind.action">推送列表</a></li1>
				<li1><a href="<%=basePath%>pushadd.jsp">添加推送</a></li1>
				<li1><a onClick="history.back(-1)">返回</a></li1>
			</ul>
		</div>
		<div class="rightinfo">
			<div class="tools">
				<ul class="toolbar">
					<li onclick="javascript:edit();"><span><img src="<%=basePath%>images/t02.png" /></span>修改</li>
					<li onclick="javascript:deleteAll();"><span><img src="<%=basePath%>images/t03.png" /></span>删除</li>
				</ul>
				<ul class="toolbar1">
					<li><input type="text" name="keyword" value="<%=keyword%>" placeholder="请输入关键字" class="findinput" /></li>
					<li><input type=hidden name=currentPage value="1" /></li>
					<li><span onclick="document.getElementById('pushlistForm').submit();">search<img src="<%=basePath%>images/t06.png" /></span></li>
				</ul>
			</div>




			<table class="tablelist">
				<thead>
					<tr>
						<th style="width:40px"><input name="checkall" type="checkbox" value="" onClick="selectAll();" /></th>
						<th style="width:60px">序号</th>
						<th>推送标题<i class="sort">
								<img src="<%=basePath%>images/px.gif" />
							</i></th>
						<th>编辑者</th>
						<th>推送URL</th>
						<th>添加时间</th>
						<th>检核状态</th>
						<th>操作</th>
					</tr>
				</thead>

				<tbody>
					<%
						int startIndex = (currentPage - 1) * PAGE_SIZE;//计算起始序号
																				for (int i = 0; i < list.size(); i++) {
																					int currentIndex = startIndex + i + 1; //当前记录的序号
																					Push push = list.get(i); //获取到对象
					%>
					<tr onclick="javascript:location.href='<%=basePath%>push/push_doView.action?push.pushId=<%=push.getPushId()%>'">
						<td><input name="check" type="checkbox" value="<%=push.getPushId()%>"></input></td>
						<td><div align="center"><%=currentIndex%></div></td>
						<td><%=push.getPushTitle()%></td>
						<td><%=push.getPushEditor()%></td>

						<td style="width:150px;"><marquee width=150px height="28px" direction="left" behavior="scroll" scrollamount="3" onmouseover="this.stop()" onmouseout="this.start()">
								<a href=""><%=push.getPushUrl()%></a>
							</marquee></td>

						<td><%=push.getPushDate()%></td>
						<td><%=push.getPushStatus()%></td>
						<td><a href="<%=basePath%>push/push_doView.action?push.pushId=<%=push.getPushId()%>" style="cursor:hand;" class="tablelink">查看</a> <a
								href="<%=basePath%>push/push_doDelete.action?push.pushId=<%=push.getPushId()%>&currentPage=<%=currentPage%>" onClick="return checkDelete()" style="cursor:hand;" class="tablelink1">删除</a></td>
					</tr>
					<%
						}
					%>
				</tbody>
			</table>


			<div class="pagin">
				<div class="message">
					共
					<i class="blue"><%=totalRecord%></i>
					条记录，当前显示第
					<i class="blue"><%=currentPage%></i>
					/<%=totalPage%>页
				</div>
				<ul class="paginList">
					<%
						if(firstPage-PAGE_SIZE>=1) {
					%>
					<li class="paginItem"><a href="<%=basePath%>push/push_doFind.action?currentPage=<%=firstPage-PAGE_SIZE%>">
							<span class="pagepre"></span>
						</a></li>
					<%
						}
					%>

					<%
						for (int i = firstPage; i <=lastPage; i++) {
																					if(i==currentPage){
					%>

					<li class="paginItem current"><a href="<%=basePath%>push/push_doFind.action?currentPage=<%=i%>"><%=i%></a></li>

					<%
						continue;}
					%>

					<li class="paginItem"><a href="<%=basePath%>push/push_doFind.action?currentPage=<%=i%>"><%=i%></a></li>

					<%
						}
					%>
					<%
						if(lastPage<totalPage){
					%>
					<li class="paginItem"><a href="<%=basePath%>push/push_doFind.action?currentPage=<%=firstPage+PAGE_SIZE%>">
							<span class="pagenxt"></span>
						</a></li>
					<%
						}
					%>
				</ul>
			</div>
		</div>
		<script type="text/javascript">
			$('.tablelist tbody tr:odd').addClass('odd');
		</script>
	</form>

</body>
</html>
