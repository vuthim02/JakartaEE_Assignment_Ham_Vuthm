<%--
  Created by IntelliJ IDEA.
  User: tim-ham
  Date: 27/08/2026
  Time: 15:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page import="java.util.Date" %>
<%-- SECURITY GUARD: If session token is missing, bounce user to login screen --%>
<c:if test="${empty sessionScope.authenticatedUser}">
    <c:redirect url="login.jsp" />
</c:if>
<%-- Mock Data Initialization using Modern Expression Language (EL 3.0+) --%>
<c:set var="product1" value="${{'name': 'ultra gaming laptop', 'price': 1299.99, 'stock':
3}}" />
<c:set var="product2" value="${{'name': 'ergonomic mechanical keyboard', 'price': 89.50,
'stock': 12}}" />
<c:set var="product3" value="${{'name': '4K ultra-wide monitor', 'price': 449.00, 'stock':
2}}" />
<c:set var="inventory" value="${{product1, product2, product3}}" />
<jsp:useBean id="reportDate" class="java.util.Date" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>E-Commerce Inventory Dashboard</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #f3f6f9; color: #1f2933; min-height: 100vh;
        }
        .topbar {
            background: linear-gradient(135deg, #0f2027, #203a43);
            padding: 18px 32px; color: #fff;
        }
        .topbar-inner {
            max-width: 1100px; margin: 0 auto;
            display: flex; align-items: center; justify-content: space-between; gap: 16px;
        }
        .brand { display: flex; align-items: center; gap: 12px; }
        .brand .logo { font-size: 30px; }
        .brand h1 { font-size: 20px; font-weight: 700; }
        .brand small { display: block; color: rgba(255,255,255,0.65); font-size: 12px; font-weight: 400; }
        .top-actions { display: flex; align-items: center; gap: 12px; }
        .user-badge {
            display: inline-flex; align-items: center; gap: 8px;
            background: rgba(255,255,255,0.12); color: #fff;
            padding: 7px 14px; border-radius: 30px; font-weight: 600; font-size: 13px;
        }
        .user-badge .avatar {
            width: 28px; height: 28px; border-radius: 50%;
            background: #2c6fb3; display: flex; align-items: center; justify-content: center;
            font-size: 14px;
        }
        .logout-btn {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 9px 16px; background: #de350b; color: #fff;
            text-decoration: none; border-radius: 8px; font-weight: 600; font-size: 13px;
            transition: background 0.2s, transform 0.15s;
        }
        .logout-btn:hover { background: #b42318; transform: translateY(-1px); }
        .container { max-width: 1100px; margin: 28px auto; padding: 0 24px; }

        .stats {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px; margin-bottom: 28px;
        }
        .stat-card {
            background: #fff; border-radius: 14px; padding: 20px;
            box-shadow: 0 6px 18px rgba(15,32,39,0.06);
            display: flex; align-items: center; gap: 14px;
            border: 1px solid #eceff3;
        }
        .stat-card .stat-icon {
            width: 46px; height: 46px; border-radius: 12px;
            display: flex; align-items: center; justify-content: center; font-size: 22px;
        }
        .stat-card .stat-icon.blue { background: #e3f0fb; }
        .stat-card .stat-icon.green { background: #e6f7ef; }
        .stat-card .stat-icon.amber { background: #fdf4e3; }
        .stat-card .stat-value { font-size: 22px; font-weight: 700; color: #1f2933; }
        .stat-card .stat-label { font-size: 13px; color: #6b7280; margin-top: 2px; }

        .panel {
            background: #fff; border-radius: 14px;
            box-shadow: 0 6px 18px rgba(15,32,39,0.06);
            border: 1px solid #eceff3; overflow: hidden;
        }
        .panel-header {
            padding: 20px 24px; border-bottom: 1px solid #eceff3;
            display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 10px;
        }
        .panel-header h2 { font-size: 17px; color: #1f2933; }
        .panel-header .sub { font-size: 13px; color: #6b7280; margin-top: 3px; }

        table { width: 100%; border-collapse: collapse; }
        thead th {
            background: #f8fafc; color: #4b5563; text-align: left;
            padding: 14px 24px; font-size: 12px; text-transform: uppercase;
            letter-spacing: 0.5px; border-bottom: 1px solid #e5e9ef;
        }
        tbody td {
            padding: 16px 24px; border-bottom: 1px solid #f0f2f5;
            font-size: 14px; vertical-align: middle;
        }
        tbody tr:last-child td { border-bottom: none; }
        tbody tr:hover { background: #fafbfd; }
        .product-name { font-weight: 600; color: #1f2933; }
        .units { color: #6b7280; font-size: 13px; }
        .badge {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 6px 12px; border-radius: 30px; font-weight: 700; font-size: 12px;
            letter-spacing: 0.3px;
        }
        .low-stock { background: #fef3f2; color: #b42318; border: 1px solid #fecdca; }
        .in-stock { background: #e6f7ef; color: #067647; border: 1px solid #abefcb; }

        .panel-footer {
            padding: 16px 24px; font-size: 13px; color: #6b7280;
            border-top: 1px solid #eceff3; display: flex; align-items: center; gap: 8px;
            background: #fafbfd;
        }
        @media (max-width: 640px) {
            .topbar-inner { flex-direction: column; align-items: flex-start; }
            thead th, tbody td { padding: 12px 14px; }
        }
    </style>
</head>
<body>
<div class="topbar">
    <div class="topbar-inner">
        <div class="brand">
            <span class="logo">🛒</span>
            <div>
                <h1>StoreKeeper</h1>
                <small>Inventory Dashboard</small>
            </div>
        </div>
        <div class="top-actions">
            <span class="user-badge">
                <span class="avatar">${fn:substring(sessionScope.authenticatedUser,0,1)}</span>
                ${sessionScope.authenticatedUser}
            </span>
            <a href="logout.jsp" class="logout-btn">→ Log Out</a>
        </div>
    </div>
</div>

<div class="container">
    <c:set var="lowStock" value="${0}" />
    <c:set var="totalValue" value="${0}" />
    <c:forEach var="item" items="${inventory}">
        <c:if test="${item.stock < 5}">
            <c:set var="lowStock" value="${lowStock + 1}" />
        </c:if>
        <c:set var="totalValue" value="${totalValue + (item.price * item.stock)}" />
    </c:forEach>

    <%-- Overview stat cards --%>
    <div class="stats">
        <div class="stat-card">
            <div class="stat-icon blue">📦</div>
            <div>
                <div class="stat-value">${fn:length(inventory)}</div>
                <div class="stat-label">Catalog Items</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon amber">⚠️</div>
            <div>
                <div class="stat-value">${lowStock}</div>
                <div class="stat-label">Low Stock Alerts</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon green">💵</div>
            <div>
                <div class="stat-value"><fmt:formatNumber value="${totalValue}" type="currency" currencySymbol="$" /></div>
                <div class="stat-label">Inventory Value</div>
            </div>
        </div>
    </div>

    <div class="panel">
        <div class="panel-header">
            <div>
                <h2>Product Catalog</h2>
                <div class="sub">Live stock levels and replenishment status</div>
            </div>
        </div>
        <table>
            <thead>
            <tr>
                <th>Product Name</th>
                <th>Unit Price</th>
                <th>Stock Level</th>
                <th>Status Alert</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="item" items="${inventory}">
                <tr>
                    <td class="product-name">${fn:toUpperCase(item.name)}</td>
                    <td><fmt:formatNumber value="${item.price}" type="currency"
                                          currencySymbol="$" /></td>
                    <td class="units">${item.stock} units</td>
                    <td>
                        <c:choose>
                            <c:when test="${item.stock < 5}">
                                <span class="badge low-stock">⚠ LOW STOCK</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge in-stock">✅ IN STOCK</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        <div class="panel-footer">
            🕒 Report compiled on: <fmt:formatDate value="${reportDate}" type="both"
                                                   dateStyle="long" timeStyle="medium" />
        </div>
    </div>
</div>
</body>
</html>