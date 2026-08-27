<%--
  Created by IntelliJ IDEA.
  User: tim-ham
  Date: 27/08/2026
  Time: 15:34
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- Force a client-side redirect back to the login screen --%>
<c:remove var="userDatabase" scope="session" />
<c:remove var="authenticatedUser" scope="session" />
<c:redirect url="login.jsp" />
