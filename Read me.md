#### Setting Up Your Spotify Developer Account

##### **Step 1: Sign Up/Log In to Spotify Developer**

Go to https://developer.spotify.com/dashboard/login

If you already are a registered Spotify user, you can use the same account to login to the developer portal. If you have not used Spotify, then you should sign up for a new free account.

Once logged into the Spotify Developer portal, you should see something like the following web page screenshot which is the Spotify Developer Portal Dashboard.

<img src="www\step_1.png" alt="step_1" style="zoom:50%;" />

##### **Step 2: Create a Spotify App in the Spotify Developer Dashboard**

Now that you are in the Spotify Developer Dashboard, you can create a Spotify App. To do this, click the "**Create an App**" button. In the page fill in the name, you want to give your app and a description. You need to check both checkboxes to agree to the usage terms and conditions. If in doubt or you want to know, you can read the terms and conditions. Then click the "**Create**" button. An example screenshot I have filled out for demo purposes is the following:

<img src="www\step_2.png" alt="step_2" style="zoom:50%;" />

Now you come back to the Dashboard page and you have your newly created Spotify App. The Client ID is displayed and you can copy this and save it and paste it into your script/code. For the Client Secret, there is an additional step of clicking the link/button to show it. Below is a screenshot of the demo example.



<img src="www\step_3.png" alt="step_3" style="zoom:50%;" />

##### **Step 3 : Configuration settings**

So while the basic needs are met of Spotify App Client ID and Client Secret in order for it to work, you need to do one more configuration setting as highlighted below to make your script work.



<img src="www\step_4.png" alt="step_4" style="zoom:50%;" />

and add following address and save

<img src="www\step_5.png" alt="step_5" style="zoom:80%;" />

<img src="www\step_5_b.png" alt="step_5_b" style="zoom:80%;" />

The Redirect URIs field is the URL location of the calling code/script. When you call the Spotify Web Services/endpoints, you need to supply the redirect URI. Here, you have to be very careful as the supplied URI has to be an exact string match for the URI that is calling the Spotify Web Services/endpoints. So even the end/trailing "/" in "https://localhost:1410/" has to be provided. Without your code hosted on HTTPS, it will not work due to security reasons to protect Spotify Users from harm.



Once you return after saving the settings to the main page

Copy and paste **Client ID** & **Client Secret** to the sidebar panel app.

Once your ID is authorized go to Get Data tab in main panel for querying and downloading data from Spotify.