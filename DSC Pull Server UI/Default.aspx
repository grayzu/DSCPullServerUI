<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="DSC_Pull_Server_UI.PullServer" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .CorporationName {
            font-size: xx-large;
            font-weight: bold;
            color: #000066;
        }
        .PageTitle {
            text-align: center;
            font-size: x-large;
            font-weight:bold;
            color: darkblue;
            height: 100px;
        }
        .SectionTitle {
            font-size:large;
            font-weight:bold;
            color:mediumblue;
        }
        .SectionDescription{
            height:50px;
        }
        nav{
            width:200px;
            float: left;
        }
        section{
            margin-left:200px;
            width:70%;
        }
        section[id="Configuration"] {
            display: none;
        }
        section[id="Reporting"] {
            display: none;
        }
        .Area{
            width:40%;
            padding:1% 5%;
            float:left;
        }
        .AreaTitle {
            font-size:medium;
            font-weight:bold;
            color:grey;
        }
        div[title="Submit"]{
            margin:auto;
            padding-top:10px;
            width:200px;
        }
        ul{
            list-style:none;
        }
        li{
            display:block;
            margin:15px 25px;
            background-color:transparent;
        }
        .Details{
            margin-top:10px;
        }
        .Results{
            margin:auto;
        }
    </style>
    <script type="text/javascript">
        function ShowDeployment() {
            document.getElementById("Deployment").style.display = "block";
            document.getElementById("Configuration").style.display = "none";
            document.getElementById("Reporting").style.display = "none";
        }
        function ShowConfiguration() {
            document.getElementById("Deployment").style.display = "none";
            document.getElementById("Configuration").style.display = "block";
            document.getElementById("Reporting").style.display = "none";
        }
        function ShowReporting() {
            document.getElementById("Deployment").style.display = "none";
            document.getElementById("Configuration").style.display = "none";
            document.getElementById("Reporting").style.display = "block";
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="PageTitle">
            <span class="CorporationName"><strong>FABRICAM</strong></span><br />
            Corporate DSC Pull Server</div>
        <div>
            <nav>
                <ul>
                    <li>
                        <a href="#" onclick="ShowDeployment()">Deployment</a>
                    </li>
                    <li title="Config">
                        <a href="#" onclick="ShowConfiguration()">Configuration</a>
                    </li>
                    <li>
                        <a href="#" onclick="ShowReporting()">Reporting</a>
                    </li>
                </ul>
            </nav>
            <section id="Deployment">
                <div class="SectionTitle">
                    Deployment
                </div>
                <div class="SectionDescription">
                   Use this panel to push configurations and resources up to the pull server. After upload the configurations and resources will be processed into the format required by the pull server.
                </div>
                <div class="Area" title="ConfigurationSelection">
                    <div class="AreaTitle">Configurations </div>
                    <div>
                    Select Node Configurations (MOFs):
                    </div>
                    <div>
                        <asp:FileUpload ID="UIConfigurationFiles" runat="server" AllowMultiple="True" Width="320px"/>
                    </div>
                </div>
                <div class="Area" title="ResourceSelection">
                    <div class="AreaTitle">Resources</div>
                    <div>
                    Select compressed resource modules:
                    </div>
                    <div>
                        <asp:FileUpload ID="UIResourceFiles" runat="server" Width="320px" AllowMultiple="True" />
                    </div>
                </div>  
                <div class="Results">

                    <asp:Label ID="Results" runat="server" ForeColor="Red"></asp:Label>

                </div>
                <div title="Submit">
                    <asp:Button ID="UIUploadFiles" runat="server" Text="Click to upload and process" OnClick="UploadFiles_Click" Width="200px" />
                </div> 
             </section>
            <section id="Configuration">
                <div class="SectionTitle">
                    Configuration
                </div>
                <div class="SectionDescription">
                   Use this panel to 
                    manage configuration assignments for target nodes. Enter the configuration name that the node should get from have into the configuration names column. When the target node checks in with the server it will download the assigned configuration.
                </div>
                <div class="Details">
                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" AutoGenerateDeleteButton="True" AutoGenerateEditButton="True" DataKeyNames="AgentId" DataSourceID="DscDB" CellPadding="7" ForeColor="#333333" GridLines="None" HorizontalAlign="Center" Width="80%">
                        <AlternatingRowStyle BackColor="White" />
                        <Columns>
                            <asp:BoundField DataField="NodeName" HeaderText="NodeName" SortExpression="NodeName" ReadOnly="True"/>
                            <asp:BoundField DataField="ConfigurationNames" HeaderText="ConfigurationNames" SortExpression="ConfigurationNames" />
                            <asp:BoundField DataField="AgentId" HeaderText="AgentId" SortExpression="AgentId" ReadOnly="True" />
                            <asp:BoundField DataField="IPAddress" HeaderText="IPAddress" SortExpression="IPAddress" ReadOnly="True"/>
                        </Columns>
                        <EditRowStyle BackColor="#2461BF" />
                        <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                        <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                        <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                        <RowStyle BackColor="#EFF3FB" />
                        <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                        <SortedAscendingCellStyle BackColor="#F5F7FB" />
                        <SortedAscendingHeaderStyle BackColor="#6D95E1" />
                        <SortedDescendingCellStyle BackColor="#E9EBEF" />
                        <SortedDescendingHeaderStyle BackColor="#4870BE" />
                    </asp:GridView>
                    <asp:SqlDataSource ID="DscDB" runat="server" ConflictDetection="CompareAllValues" ConnectionString="<%$ ConnectionStrings:DscDbConnectionString %>" DeleteCommand="DELETE FROM [RegistrationData] WHERE [AgentId] = ? AND (([NodeName] = ?) OR ([NodeName] IS NULL AND ? IS NULL)) AND (([ConfigurationNames] = ?) OR ([ConfigurationNames] IS NULL AND ? IS NULL)) AND (([IPAddress] = ?) OR ([IPAddress] IS NULL AND ? IS NULL))" InsertCommand="INSERT INTO [RegistrationData] ([NodeName], [ConfigurationNames], [AgentId], [IPAddress]) VALUES (?, ?, ?, ?)" OldValuesParameterFormatString="original_{0}" ProviderName="<%$ ConnectionStrings:DscDbConnectionString.ProviderName %>" SelectCommand="SELECT [NodeName], [ConfigurationNames], [AgentId], [IPAddress] FROM [RegistrationData]" UpdateCommand="UPDATE [RegistrationData] SET [NodeName] = ?, [ConfigurationNames] = ?, [IPAddress] = ? WHERE [AgentId] = ? AND (([NodeName] = ?) OR ([NodeName] IS NULL AND ? IS NULL)) AND (([ConfigurationNames] = ?) OR ([ConfigurationNames] IS NULL AND ? IS NULL)) AND (([IPAddress] = ?) OR ([IPAddress] IS NULL AND ? IS NULL))">
                        <DeleteParameters>
                            <asp:Parameter Name="original_AgentId" Type="String" />
                            <asp:Parameter Name="original_NodeName" Type="String" />
                            <asp:Parameter Name="original_NodeName" Type="String" />
                            <asp:Parameter Name="original_ConfigurationNames" Type="String" />
                            <asp:Parameter Name="original_ConfigurationNames" Type="String" />
                            <asp:Parameter Name="original_IPAddress" Type="String" />
                            <asp:Parameter Name="original_IPAddress" Type="String" />
                        </DeleteParameters>
                        <InsertParameters>
                            <asp:Parameter Name="NodeName" Type="String" />
                            <asp:Parameter Name="ConfigurationNames" Type="String" />
                            <asp:Parameter Name="AgentId" Type="String" />
                            <asp:Parameter Name="IPAddress" Type="String" />
                        </InsertParameters>
                        <UpdateParameters>
                            <asp:Parameter Name="NodeName" Type="String" />
                            <asp:Parameter Name="ConfigurationNames" Type="String" />
                            <asp:Parameter Name="IPAddress" Type="String" />
                            <asp:Parameter Name="original_AgentId" Type="String" />
                            <asp:Parameter Name="original_NodeName" Type="String" />
                            <asp:Parameter Name="original_NodeName" Type="String" />
                            <asp:Parameter Name="original_ConfigurationNames" Type="String" />
                            <asp:Parameter Name="original_ConfigurationNames" Type="String" />
                            <asp:Parameter Name="original_IPAddress" Type="String" />
                            <asp:Parameter Name="original_IPAddress" Type="String" />
                        </UpdateParameters>
                    </asp:SqlDataSource>
                </div>
            </section>
            <section id="Reporting">
                <div class="SectionTitle">
                    Reporting
                </div>
                <div class="SectionDescription">
                   Use this panel to view the state of configuration across your environment. The table contains information about every configuration pass for every node configured to report to this server.
                </div>
                <div class="Details">
                    <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" DataKeyNames="JobId" DataSourceID="ReportData" CellPadding="7" ForeColor="#333333" GridLines="None" HorizontalAlign="Center" Width="80%">
                        <AlternatingRowStyle BackColor="White" />
                        <Columns>
                            <asp:BoundField DataField="NodeName" HeaderText="NodeName" SortExpression="NodeName" />
                            <asp:BoundField DataField="OperationType" HeaderText="OperationType" SortExpression="OperationType"/>
                            <asp:BoundField DataField="StartTime" HeaderText="StartTime" SortExpression="StartTime" />
                            <asp:BoundField DataField="EndTime" HeaderText="EndTime" SortExpression="EndTime" />
                            <asp:BoundField DataField="StatusData" HeaderText="StatusData" SortExpression="StatusData" />
                            <asp:BoundField DataField="Errors" HeaderText="Errors" SortExpression="Errors" />
                            <asp:BoundField DataField="RebootRequested" HeaderText="RebootRequested" SortExpression="RebootRequested" />
                        </Columns>
                        <EditRowStyle BackColor="#2461BF" />
                        <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                        <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                        <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                        <RowStyle BackColor="#EFF3FB" />
                        <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                        <SortedAscendingCellStyle BackColor="#F5F7FB" />
                        <SortedAscendingHeaderStyle BackColor="#6D95E1" />
                        <SortedDescendingCellStyle BackColor="#E9EBEF" />
                        <SortedDescendingHeaderStyle BackColor="#4870BE" />
                    </asp:GridView>
                    <asp:SqlDataSource ID="ReportData" runat="server" ConnectionString="<%$ ConnectionStrings:DscDbConnectionString %>" OldValuesParameterFormatString="original_{0}" ProviderName="<%$ ConnectionStrings:DscDbConnectionString.ProviderName %>" SelectCommand="SELECT [NodeName], [JobId], [OperationType], [RefreshMode], [StartTime], [EndTime], [StatusData], [Errors], [RebootRequested], [IPAddress] FROM [StatusReport]">
                    </asp:SqlDataSource>
                </div>
            </section>
        </div>
    </form>
</body>
</html>
