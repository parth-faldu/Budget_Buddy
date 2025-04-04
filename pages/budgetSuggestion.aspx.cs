using System;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using System.Web.UI;
using Newtonsoft.Json;
using System.Configuration;
using System.Diagnostics;
using System.Text.RegularExpressions;

namespace Budget_Budddy.pages
{
    public partial class budgetSuggestion : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["username"] == null)
            {
                Response.Redirect("../index.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }
            litUsername.Text = Session["username"].ToString();

            if (!IsPostBack)
            {
                // Initialize chat history with a greeting from the AI.
                litChatHistory.Text = "<div class='chat-message ai-message'>Hello! I'm here to chat with you. How can I help today?</div>";
            }
        }

        protected void btnSendMessage_Click(object sender, EventArgs e)
        {
            Page.RegisterAsyncTask(new PageAsyncTask(ProcessChatMessageAsync));
        }

        private async Task ProcessChatMessageAsync()
        {
            string userMessage = txtUserMessage.Text.Trim();
            if (string.IsNullOrEmpty(userMessage))
            {
                return;
            }

            // Append the user's message to the chat history.
            AppendChatMessage("user", userMessage);
            txtUserMessage.Text = "";
            await Task.Delay(1000); // Simulate a short processing delay

            // Get a response from the AI API based on the user's message.
            string aiResponse = await GetChatResponseAsync(userMessage);
            AppendChatMessage("ai", aiResponse);
        }

        private void AppendChatMessage(string sender, string message)
        {
            string cssClass = sender == "user" ? "user-message" : "ai-message";
            // Replace newline characters with <br /> tags to preserve formatting.
            message = message.Replace("\n", "<br />");

            // Replace markdown bold syntax (**text**) with HTML <strong> tags.
            message = Regex.Replace(message, @"\*\*(.*?)\*\*", "<strong>$1</strong>");

            // Append new message to the existing chat history.
            litChatHistory.Text += $"<div class='chat-message {cssClass}'>{message}</div>";
        }

        private async Task<string> GetChatResponseAsync(string userMessage)
        {
            // Construct the prompt for the AI.
            string prompt = $"User: {userMessage}\nAI:";
            var requestBody = new
            {
                contents = new[]
                {
                    new { parts = new[] { new { text = prompt } } }
                }
            };

            string apiKey = ConfigurationManager.AppSettings["Gemini_API_Key"];
            string endpoint = $"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key={apiKey}";

            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                var json = JsonConvert.SerializeObject(requestBody);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                HttpResponseMessage response = await client.PostAsync(endpoint, content);
                if (response.IsSuccessStatusCode)
                {
                    string responseString = await response.Content.ReadAsStringAsync();
                    Debug.WriteLine("Gemini API response: " + responseString);
                    dynamic result = JsonConvert.DeserializeObject(responseString);

                    if (result != null && result.candidates != null && result.candidates.Count > 0)
                    {
                        var candidate = result.candidates[0];
                        if (candidate.content != null &&
                            candidate.content.parts != null &&
                            candidate.content.parts.Count > 0 &&
                            candidate.content.parts[0].text != null)
                        {
                            return candidate.content.parts[0].text.ToString().Trim();
                        }
                        else
                        {
                            return "Unexpected response format from the AI API.";
                        }
                    }
                    else
                    {
                        return "No response received from the AI API.";
                    }
                }
                else
                {
                    string errorDetails = await response.Content.ReadAsStringAsync();
                    return $"Error from AI API. Status Code: {response.StatusCode}. Details: {errorDetails}";
                }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Cache.SetCacheability(System.Web.HttpCacheability.NoCache);
            Response.Redirect("../index.aspx", true);
        }
    }
}
