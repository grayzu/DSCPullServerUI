##Description
This repo contains a very simple sample ASP.NET user interface for the DSC pull server included with WMF 5.0. This UI enables the following three features:
#### 1. Uploading DSC configurations and resources to pull server
Without this feature, a user needs to package up node configurations (mof) and DSC resources into a specific format and then copy them to the appropriate pull server folder. This feature allows the user to simply select the node configurations (mof) and archived (zipped) DSC resources. All of the selected configurations and DSC resources will be packaged appropriately and dropped into the appropriate folders on the pull server where they will be ready for target nodes to retrieve them.

#### 2. See and change configuration assignment to nodes.
With this version of WMF, the pull server can control which configuration each target node receives. This is controlled by a table in the pull server's database. This table content can be set at registration time by way of the ConfigurationName property in each target nodes meta-configuration. This is not always the most desirable way to assign configurations to nodes, however, and without this UI there is no good way to do this centrally. This UI allows an administrator to assign the node configuration (mof) that a target node should receive by setting the _Configuration Names_ field to the appropriate configuration name. The configuration name must be in json format. For example: ['Basic.WebFrontEndServer']

#### 3. View Target Node reporting information.
Each target node now sends up all of the information found in get-DscConfigurationStatus cmdlet to the pull server. All of this information is stored in the pull server's database. This feature provides a very raw view of all of the reporting information. The bulk of the interesting information is stored as raw json in the _StatusData_ field.

##Session 
[What's Up with DSC Pull Server](https://www.youtube.com/watch?v=y3-_XBQTpS8) (YouTube Video)

##Repo contents
Visual Studio solution and associated C# and ASPX code files.

##See Also
Use the configuration from the [PSSummitEU2015](https://github.com/grayzu/PSSummitEU2015) Repo to deploy the pull server and install this WebApp to the default website.
