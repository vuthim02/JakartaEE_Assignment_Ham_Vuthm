<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- STEP 1: Define the Authorized Users List using EL Map Syntax --%>
<c:set var="userDatabase" value="${{
 'admin': '111',
 'user': '222',
 'guest': '333'
}}" scope="session" />
<%-- STEP 2: Handle Authentication Logic if Form is Submitted --%>
<c:if test="${pageContext.request.method eq 'POST'}">
    <c:set var="inputUser" value="${param.username}" />
    <c:set var="inputPass" value="${param.password}" />

    <%-- Lookup the password associated with the username in our map --%>
    <c:set var="correctPassword" value="${userDatabase[inputUser]}" />

    <c:choose>
        <%-- Check if user exists and password matches --%>
        <c:when test="${not empty correctPassword && correctPassword eq inputPass}">
            <%-- Initialize a session variable to track successful authentication --%>
            <c:set var="authenticatedUser" value="${inputUser}" scope="session" />

            <%-- Route user safely to the dashboard --%>
            <c:redirect url="inventory.jsp" />
        </c:when>
        <c:otherwise>
            <%-- Set temporary error message if validation checks fail --%>
            <c:set var="loginErrorMessage" value="Invalid username or password. Please try again." />
        </c:otherwise>
    </c:choose>
</c:if>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enterprise Login</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #0f2027 0%, #203a43 50%, #2c5364 100%);
            padding: 20px;
        }
        .login-wrap { width: 100%; max-width: 400px; }
        .brand { text-align: center; margin-bottom: 24px; }
        .brand .logo {
            font-size: 44px; display: block; margin-bottom: 8px; }
        .brand h1 { color: #fff; font-size: 24px; font-weight: 700; }
        .brand p { color: rgba(255,255,255,0.7); font-size: 14px; margin-top: 4px; }
        .login-card {
            background: #ffffff;
            padding: 36px 32px;
            border-radius: 16px;
            box-shadow: 0 25px 60px rgba(0,0,0,0.35);
        }
        .login-card h2 { font-size: 20px; color: #1f2933; margin-bottom: 4px; }
        .login-card .sub { color: #6b7280; font-size: 13px; margin-bottom: 24px; }
        .form-group { margin-bottom: 18px; }
        label {
            display: block; margin-bottom: 7px; font-weight: 600;
            color: #374151; font-size: 13px; letter-spacing: 0.2px;
        }
        .input-wrap { position: relative; }
        .input-wrap .icon {
            position: absolute; left: 13px; top: 50%; transform: translateY(-50%);
            font-size: 16px; color: #9ca3af; pointer-events: none;
        }
        input[type="text"], input[type="password"] {
            width: 100%; padding: 12px 12px 12px 40px;
            border: 1px solid #d1d5db; border-radius: 10px;
            font-size: 14px; color: #1f2933; background: #fafafa;
            transition: border-color 0.2s, box-shadow 0.2s, background 0.2s;
            outline: none;
        }
        input:focus {
            background: #fff; border-color: #2c6fb3;
            box-shadow: 0 0 0 3px rgba(44,111,179,0.15);
        }
        button {
            width: 100%; padding: 13px; margin-top: 8px;
            background: linear-gradient(135deg, #2c6fb3, #1f4e8f);
            color: #fff; border: none; border-radius: 10px;
            font-weight: 700; font-size: 15px; cursor: pointer;
            transition: transform 0.15s, box-shadow 0.2s, opacity 0.2s;
            box-shadow: 0 8px 20px rgba(44,111,179,0.3);
        }
        button:hover { opacity: 0.95; transform: translateY(-1px); }
        button:active { transform: translateY(0); }
        .error-msg {
            display: flex; align-items: center; gap: 8px;
            color: #b42318; background: #fef3f2; padding: 12px 14px;
            border-radius: 10px; font-size: 13px; margin-bottom: 20px;
            border: 1px solid #fecdca;
        }
        .demo-hint {
            margin-top: 22px; padding-top: 18px; border-top: 1px dashed #e5e7eb;
            text-align: center; color: #6b7280; font-size: 12px; line-height: 1.8;
        }
        .demo-hint code {
            background: #f3f4f6; padding: 2px 7px; border-radius: 6px;
            color: #1f2933; font-weight: 600; font-size: 11px;
        }
    </style>
</head>
<body>
<div class="login-wrap">
    <div class="brand">
        <span class="logo">🛒</span>
        <h1>StoreKeeper</h1>
        <p>Enterprise Inventory Management</p>
    </div>
    <div class="login-card">
        <h2>Welcome back</h2>
        <p class="sub">Sign in to access your inventory dashboard</p>

        <%-- Render errors dynamically without raw expression scriptlets --%>
        <c:if test="${not empty loginErrorMessage}">
            <div class="error-msg">⚠ ${loginErrorMessage}</div>
        </c:if>
        <form action="login.jsp" method="POST">
            <div class="form-group">
                <label for="username">Username</label>
                <div class="input-wrap">
                    <span class="icon">👤</span>
                    <input type="text" id="username" name="username" placeholder="Enter your username" required autocomplete="off">
                </div>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <div class="input-wrap">
                    <span class="icon">🔒</span>
                    <input type="password" id="password" name="password" placeholder="Enter your password" required>
                </div>
            </div>
            <button type="submit">Sign In</button>
        </form>
        <div class="demo-hint">
            Demo credentials: <code>admin / 111</code> · <code>user / 222</code> · <code>guest / 333</code>
        </div>
    </div>
</div>
</body>
</html>