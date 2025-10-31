# Enable SCCM Azure Active Directory (AAD) User Discovery

## Azure AD Requirements

Before configuring the new discovery method, you’ll need to have :

- A valid Azure Tenant
- Access to your Azure admin portal

## SCCM 1706 Configuration

The first step is to configure the Azure Services in SCCM. This step 
will automatically create the web app in your Azure tenant, there’s no 
need to create it manually, SCCM takes care of it.

- Open the SCCM Console, go to **Administration / Cloud Services / Azure Services**
- Right-Click **Azure Services** and select **Configure Azure Services**

![SCCM Azure Active Directory](https://systemcenterdudes.com/wp-content/uploads/2017/09/36646-1.png)

- In the **Azure Service wizard**, name your Azure Service and select **Cloud Management** in the bottom pane

![SCCM Azure Active Directory](https://systemcenterdudes.com/wp-content/uploads/2017/09/36646-2.png)

- In the **App** pane, click **Browse** to select your web app

![SCCM Azure Active Directory](https://systemcenterdudes.com/wp-content/uploads/2017/09/36646-3.png)

- In the Server App window, click Create to create the web app

![SCCM Azure Active Directory](https://systemcenterdudes.com/wp-content/uploads/2017/09/36646-4.png)

- **Application Name**: Provide a name for the app
- **HomePage URL**: Provide the homepage URL for the app. (This URL doesn’t need to resolve)
- **App ID URI**: Provide the identifier URL for the app (This URL doesn’t need to resolve)
- **Secret key validity period**: Select **1 Year** or **2 Years** for the key validity period
- **Azure AD Admin Account**: Sign in with your tenant administrator account
- **Azure AD Tenant Name**: Will be automatically populated after signing in

![SCCM Azure Active Directory](https://systemcenterdudes.com/wp-content/uploads/2017/09/36646-5.png)

![SCCM Azure Active Directory](https://systemcenterdudes.com/wp-content/uploads/2017/09/36646-6.png)

- Once the login is successful, click **Ok.** The app
will be automatically created in your tenant. If the app already exists, it will prompt saying that it already exists and the existing one will
be reused.

![SCCM Azure Active Directory](https://systemcenterdudes.com/wp-content/uploads/2017/09/36646-7.png)

- Back in the **App** pane, click **Browse** to select a **Native Client App**

![SCCM Azure Active Directory](https://systemcenterdudes.com/wp-content/uploads/2017/09/36646-8.png)

- In the **Client App** window, click **Create**

![SCCM Azure Active Directory](https://systemcenterdudes.com/wp-content/uploads/2017/09/36646-9.png)

- **Application Name**: Provide a name for the app
- **Reply URL:** Provide the reply URL for the app. (This URL doesn’t need to resolve)
- **Azure AD Admin Account**: Sign in with your tenant administrator account
- **Azure AD Tenant Name**: Will be automatically populated after signing in
- Once the login is successful, click **Ok.** The app
will be automatically created in your tenant. If the app already exists, it will prompt saying that it already exists and the existing one will
be reused.

![SCCM Azure Active Directory](https://systemcenterdudes.com/wp-content/uploads/2017/09/36646-10.png)

- Select your newly created App and click **Ok**

![SCCM Azure Active Directory](https://systemcenterdudes.com/wp-content/uploads/2017/09/36646-11.png)

- Back in the **App** pane, click **Next**

![SCCM Azure Active Directory](https://systemcenterdudes.com/wp-content/uploads/2017/09/36646-12.png)

- Check the **Enable Azure Active Directory User Discovery** check box, click **Settings**

![SCCM Azure Active Directory](https://systemcenterdudes.com/wp-content/uploads/2017/09/36646-13.png)

- Select your preferred **Full Discovery Schedule** and decide to enable or not the **Delta discovery**, click **Ok**

![SCCM Azure Active Directory](https://systemcenterdudes.com/wp-content/uploads/2017/09/36646-14.png)

- Review your settings and complete the wizard

![SCCM Azure Active Directory](https://systemcenterdudes.com/wp-content/uploads/2017/09/36646-15.png)

![SCCM Azure Active Directory](https://systemcenterdudes.com/wp-content/uploads/2017/09/36646-16.png)

- Once created, you can run a **Full Discovery** now but further configuration must be made

![SCCM Azure Active Directory](https://systemcenterdudes.com/wp-content/uploads/2017/09/36646-17.png)

- If ran now, the discovery will fail. You can view status in the **SMS_AZUREAD_DISCOVERY_AGENT.log** file.

![SCCM Azure Active Directory](https://systemcenterdudes.com/wp-content/uploads/2017/09/36646-18.png)

## Azure Configuration

We now need to grant permissions on both the client app and server app in Azure.

- Log in your [Azure Admin portal](http://portal.azure.com/)
- Select **App Registration**
- Our 2 app is displayed :

![SCCM Azure Active Directory](https://systemcenterdudes.com/wp-content/uploads/2017/09/36646-19.png)

- Select one of the app, click **All Settings**, select **Required Permissions**

![SCCM Azure Active Directory](https://systemcenterdudes.com/wp-content/uploads/2017/09/36646-20.png)

- On the top, select **Grant permissions**

![SCCM Azure Active Directory](https://systemcenterdudes.com/wp-content/uploads/2017/09/36646-21.png)

- Click **Yes**

![SCCM Azure Active Directory](https://systemcenterdudes.com/wp-content/uploads/2017/09/36646-22.png)

- Wait for the confirmation that the permission has been granted. Once completed, redo the step for your other app and close the Azure portal.

![SCCM Azure Active Directory](https://systemcenterdudes.com/wp-content/uploads/2017/09/36646-23.png)

## SCCM Azure Active Directory Validation

Once the app permission has been granted the **SMS_AZUREAD_DISCOVERY_AGENT.log** will start to show successful discovery

![SCCM Azure Active Directory](https://systemcenterdudes.com/wp-content/uploads/2017/09/36646-24.png)

You can confirm that an account has been discovered by Azure Discovery by looking at its properties :

![SCCM Azure Active Directory](https://systemcenterdudes.com/wp-content/uploads/2017/09/36646-25.png)