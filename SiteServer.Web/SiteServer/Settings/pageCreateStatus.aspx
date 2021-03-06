﻿<%@ Page Language="C#" Inherits="SiteServer.BackgroundPages.Settings.PageCreateStatus" %>
  <%@ Register TagPrefix="bairong" Namespace="SiteServer.BackgroundPages.Controls" Assembly="SiteServer.BackgroundPages" %>
    <!DOCTYPE html>

    <html>

    <head>
      <meta charset="utf-8">
      <!--#include file="../inc/head.html"-->
      <script type="text/javascript" src="../assets/signalR/jquery.signalR-2.2.1.min.js"></script>
      <script src="/signalr/hubs"></script>
      <script language="javascript" src="../inc/script.js"></script>
      <script type="text/javascript">
        var siteId = <%=PublishmentSystemId%>;

        $(function () {
          var create = $.connection.createHub;
          create.client.show = function (isOnline, tasks, channelsCount, contentsCount, filesCount) {
            if (!isOnline) {
              $('#online').hide();
              $('#offline').show();
              return;
            }
            $('#tasks').html('');
            $('#channelsCount').text(channelsCount);
            channelsCount ? $('#channelsCount').css('color', '#fa0') : $('#channelsCount').css('color', '#00b19d');
            $('#contentsCount').text(contentsCount);
            contentsCount ? $('#contentsCount').css('color', '#fa0') : $('#contentsCount').css('color', '#00b19d');
            $('#filesCount').text(filesCount);
            filesCount ? $('#filesCount').css('color', '#fa0') : $('#filesCount').css('color', '#00b19d');
            if (tasks && tasks.length > 0) {
              for (var i = 0; i < tasks.length; i++) {
                var task = tasks[i];
                if (task.isExecuting) {
                  $('#tasks').append(
                    '<div class="form-group form-row"><label for="range_01" class="col-2 col-form-label">' +
                    task.type +
                    '<span class="font-normal text-muted clearfix">正在生成...</span></label><div class="col-10"><div class="progress progress-lg m-b-5" style="margin-top: 18px"><div class="progress-bar progress-bar progress-bar-striped active" role="progressbar" aria-valuenow="96" aria-valuemin="0" aria-valuemax="100" style="width: 100%;">' +
                    task.name + '</div></div></div></div>');
                } else if (task.isPending) {
                  $('#tasks').append(
                    '<div class="form-group form-row"><label for="range_01" class="col-2 col-form-label">' +
                    task.type +
                    '<span class="font-normal text-muted clearfix">等待中</span></label><div class="col-10"><div class="progress progress-lg m-b-5" style="margin-top: 18px"><div class="progress-bar progress-bar-warning progress-bar-striped active" role="progressbar" aria-valuenow="96" aria-valuemin="0" aria-valuemax="100" style="width: 100%;">' +
                    task.name + '</div></div></div></div>');
                } else {
                  if (task.isSuccess) {
                    $('#tasks').append(
                      '<div class="form-group form-row"><label for="range_01" class="col-2 col-form-label">' +
                      task.type +
                      '<span class="font-normal text-muted clearfix">生成成功</span></label><div class="col-10"><div class="progress progress-lg m-b-5" style="margin-top: 18px"><div class="progress-bar progress-bar-primary" role="progressbar" aria-valuenow="96" aria-valuemin="0" aria-valuemax="100" style="width: 100%;"><a href="<%=SiteUrl%>&channelId=' +
                      task.channelId + '&contentId=' + task.contentId + '&templateId=' + task.templateId +
                      '" target="_blank" style="color:#fff;">' + task.name + '（用时：' + task.timeSpan + '）' +
                      '</a></div></div></div></div>');
                  } else {
                    $('#tasks').append(
                      '<div class="form-group form-row"><label for="range_01" class="col-2 col-form-label">' +
                      task.type +
                      '<span class="font-normal text-muted clearfix">生成失败</span></label><div class="col-10"><div class="progress progress-lg m-b-5" style="margin-top: 18px"><div class="progress-bar progress-bar-danger" role="progressbar" aria-valuenow="96" aria-valuemin="0" aria-valuemax="100" style="width: 100%;">' +
                      task.name + '（错误：' + task.errorMessage + '）' + '</div></div></div></div>');
                  }
                }
              }
            }

            setTimeout(function () {
              create.server.getTasks(siteId);
            }, 3000);
          };
          create.client.next = function (total) {
            if (total) {
              create.server.execute(siteId);
            }
          };
          $.connection.hub.start().done(function () {
            create.server.getTasks(siteId);
          });
        });
      </script>
    </head>

    <body>
      <form class="m-l-15 m-r-15" runat="server">
        <div id="offline" class="row" style="display: none; ">
          <div class="col-12">
            <div class="card-box">
              <div class="row">

                <div class="col-12">
                  <div class="alert alert-danger fade in m-b-0">
                    <h4>siteserver.exe 服务组件未启动</h4>
                    <p>
                      siteserver.exe 服务组件未启动，请在SiteServer系统根目录下双击运行siteserver.exe程序启用服务。
                    </p>
                  </div>
                </div>

              </div>
            </div>
          </div>
        </div>

        <div id="online" class="row">
          <div class="col-12">

            <div class="card-box">

              <div class="row app-countdown">
                <div class="col-12">
                  <div>
                    <div>
                      <h3>剩余页面：</h3>
                    </div>
                    <div>
                      <span id="channelsCount" style="color: #00b19d">0</span>
                      <span>
                        <b>栏目页</b>
                      </span>
                    </div>
                    <div>
                      <span id="contentsCount" style="color: #00b19d">0</span>
                      <span>
                        <b>内容页</b>
                      </span>
                    </div>
                    <div>
                      <span id="filesCount" style="color: #00b19d">0</span>
                      <span>
                        <b>文件页</b>
                      </span>
                    </div>
                  </div>
                </div>
              </div>

              <div id="tasks">
                <div class="progress">
                  <div role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 20%;" class="progress-bar progress-bar-success progress-bar-striped"></div>
                  <div role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 10%;" class="progress-bar progress-bar-info"></div>
                  <div role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 15%;" class="progress-bar progress-bar-warning progress-bar-striped active"></div>
                  <div role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 30%;" class="progress-bar progress-bar-danger progress-bar-striped active"></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </form>
    </body>
    <!--#include file="../inc/foot.html"-->