<% import com.browsersoft.utils.DOMUtils; %>
<% import com.browsersoft.medicalflow.data.bundles.BundleUtils; %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
    <title><%= BundleUtils.resolveBundleItems(portalTitle, bundleService) %><%=(useSubtitles)?(" - "+appName):""%></title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="/portal.css" type="text/css"/>
    <script src="/js/lib/jquery-1.11.0.min.js"></script>
    <script src="/portal.js" type="text/javascript"></script>
</head>
<body language="<%= bundleService.getLanguage() %> language">
<div id="topLogin">
    <div id="loginCopyright">
        <!--<%= bundleService.getBundleItem("webportal.Copyright") %> &#169; <%= Calendar.getInstance().get(Calendar.YEAR) %>, <a href="http://www.browsersoft.com/">Browsersoft, <%= bundleService.getBundleItem("webportal.Inc") %>.</a>, <%= bundleService.getBundleItem("webportal.AllRightsReserved") %>-->
    </div>
    <div id="logoLoginContainer">
        <img id="logoLogin" src="/OpenHRE-logo.png"/>
    </div>
    <div id="availableLanguages" style="padding: 8px">
        <% if (availableLanguages.size() > 1) { availableLanguages.each { %>
        <span class="<%= it %> language flag"><a href="?language=<%= it %>"><img src="/flags/<%= it %>.png"/></a></span>
        <%}}%>
    </div>
</div>
<div id="loginCenter">
     <form action="" method="POST">
        <div id="login_dialog" <% if (providers.size() > 0) { %> style="width: 500px" <% } %>>
            <div id="login_title" <% if (providers.size() > 0) { %> style="top: 30px; left: 10px" <% } %>>
                <%= bundleService.getBundleItem("webportal.SignIn")%> <% if (providers.size() > 0) { %> using <select class="styledCombo" name="form_provider" size="1">
                <% for (String providerId : providers) { %>
                <option value="<%= providerId %>"><%= providerDesc.get(providerId) %></option>
                <% } %>
                </select>
                <% } %>
            </div>
            <div id="login_user_name">
                <%= bundleService.getBundleItem("webportal.Username") %>
            </div>
            <div id="login_password">
                <%= bundleService.getBundleItem("webportal.Password") %>
            </div>
            <input type="text" name="form_user" id="login_input_user" value="<%=  DOMUtils.stringToEntity(user) %>"  class="inputField" autofocus/>
            <input type="password" name="form_password" id="login_input_password" class="inputField"/>
            <input type="hidden" name="id" value=""/>
            <input type="submit" id="login_submit" name="login_submit" class="formSubmitButton" value="<%= bundleService.getBundleItem("webportal.LogIn") %>"/>
            <% if (passwordResetEnabled) { %><div id="login_forgot_password"><a class="styledA" href="/reset_password"><%= bundleService.getBundleItem("webportal.ForgotPassword?") %></a></div><% } %>
        </div>
    </form>
    <% if ( !message.equals("") ) { %>
        <span class="loginAlert"><%= BundleUtils.resolveBundleItems(message, bundleService) %></span>
    <% } %>
</div>
</body>
</html>

