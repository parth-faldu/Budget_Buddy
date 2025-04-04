<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="budgetSuggestion.aspx.cs" Inherits="Budget_Budddy.pages.budgetSuggestion" Async="true" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Chat AI - Budget Buddy</title>
    <link rel="stylesheet" href="../Styles/budegtSuggestion.css" />
    <link rel="stylesheet" href="../Styles/header.css" />add
    <link rel="stylesheet" href="../Styles/sidebar.css" />
    <link rel="stylesheet" href="../Styles/baseStyle.css" />
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css"
          integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg=="
          crossorigin="anonymous"
          referrerpolicy="no-referrer" />
    <!-- Client-side script to show inline loader and scroll chat container -->
    <script type="text/javascript">
        // When the async postback begins, insert an inline loader as a chat bubble.
        Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(function () {
            var chatContainer = document.getElementById("chatContainer");
            if (chatContainer && !document.getElementById("tempLoader")) {
                var loaderDiv = document.createElement("div");
                loaderDiv.id = "tempLoader";
                loaderDiv.className = "chat-message ai-message";
                loaderDiv.innerHTML = "<span class='loader-chat'></span>";
                chatContainer.appendChild(loaderDiv);
                chatContainer.scrollTop = chatContainer.scrollHeight;
            }
        });
        // When the async postback ends, remove the inline loader and scroll to the bottom.
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
            var loader = document.getElementById("tempLoader");
            if (loader) {
                loader.parentNode.removeChild(loader);
            }
            var chatContainer = document.getElementById("chatContainer");
            if (chatContainer) {
                chatContainer.scrollTop = chatContainer.scrollHeight;
            }
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
        <div class="sidebar">
            <ul>
                <li><a href="dashboard.aspx"><i class="fa-solid fa-chart-line"></i> Dashboard</a></li>
                <li><a href="addExpense.aspx"><i class="fa-solid fa-wallet"></i> Add Expenses</a></li>
                <li><a href="manageExpense.aspx"><i class="fa-solid fa-wallet"></i> Manage Expenses</a></li>
                <li><a href="budget.aspx"><i class="fa-solid fa-coins"></i> Budget AI</a></li>
                <li><a href="reports.aspx"><i class="fa-solid fa-file-alt"></i> Reports</a></li>
                <li><a href="settings.aspx"><i class="fa-solid fa-cog"></i> Settings</a></li>
                <li>
                    <asp:LinkButton ID="btnLogoutSidebar" runat="server" OnClick="btnLogout_Click">
                        <i class="fa-solid fa-sign-out-alt"></i> Logout
                    </asp:LinkButton>
                </li>
            </ul>
        </div>
        <div class="main-content">
            <div class="header">
                <h2>Budget Buddy</h2>
                <div class="user-settings-con">
                    <h2>Welcome, <asp:Literal ID="litUsername" runat="server"></asp:Literal></h2>
                </div>
            </div>
            <!-- Chat Section -->
            <div class="suggestions-section chat-section">
                <h3 class="chat-title">Chat AI</h3>
                <asp:UpdatePanel ID="upChat" runat="server">
                    <ContentTemplate>
                        <!-- Chat History Container -->
                        <div class="chat-container" id="chatContainer">
                            <asp:Literal ID="litChatHistory" runat="server"></asp:Literal>
                            <!-- (Optional) Full overlay UpdateProgress is now hidden -->
                            <asp:UpdateProgress ID="upProgress" runat="server" AssociatedUpdatePanelID="upChat" DisplayAfter="0">
                                <ProgressTemplate>
                                    <div class="chat-message ai-message loader-width">
                                        <div class="loader-container">
                                            <span class="loader"></span>
                                        </div>
                                    </div>
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                        </div>
                        <!-- Chat Input Container -->
                        <div class="chat-input-container">
                            <asp:TextBox ID="txtUserMessage" runat="server" CssClass="input-box" placeholder="Type your message..."></asp:TextBox>
                            <asp:LinkButton ID="btnSendMessage" runat="server" Text="Send" CssClass="suggestion-btn" OnClick="btnSendMessage_Click" CausesValidation="false" />
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnSendMessage" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
        <asp:HiddenField ID="hiddenExpenseData" runat="server" />
    </form>
</body>
</html>
