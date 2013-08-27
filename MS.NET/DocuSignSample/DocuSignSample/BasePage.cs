﻿using DocuSignSample.DocuSignAPI;
using DocuSignSample.resources;
using System;
using System.Collections;
using System.Configuration;

namespace DocuSignSample
{
    public class BasePage : System.Web.UI.Page
    {
        
        public APIServiceSoapClient CreateAPIProxy()
        {
            var creds = GetAPICredentials();
            var apiClient = new APIServiceSoapClient(Keys.ApiServiceSoap, creds.ApiUrl);
            if (null != apiClient.ClientCredentials)
            {
                apiClient.ClientCredentials.UserName.UserName = creds.UserName;
                apiClient.ClientCredentials.UserName.Password = creds.Password;
            }

            return apiClient;
        }

        public AccountCredentials GetAPICredentials()
        {
            var credentials = new AccountCredentials();
            if (SettingIsSet(Keys.ApiUrl) && 
                null != Session[Keys.ApiAccountId] && 
                null != Session[Keys.ApiEmail] &&
                null != Session[Keys.ApiPassword])
            {
                credentials.AccountId = (string) Session[Keys.ApiAccountId];
                credentials.UserName = "[" + (string) Session[Keys.ApiIkey] + "]";
                credentials.UserName += (string) Session[Keys.ApiUserId];
                credentials.Password = (string) Session[Keys.ApiPassword];
                credentials.ApiUrl = ConfigurationManager.AppSettings[Keys.ApiUrl];
            }
            else
            {
                GoToErrorPage("Please make sure your credentials are entered in web.config");
            }
            return credentials;
        }

        public void GoToErrorPage(string errorMessage)
        {
            Session[Keys.ErrorMessage] = errorMessage;
            Response.Redirect("error.aspx", true);
        }

        public bool SettingIsSet(string settingName)
        {
            // check if a value is specified in the config file
            return (ConfigurationManager.AppSettings[settingName] != null &&
                    ConfigurationManager.AppSettings[settingName].Length > 0);
        }

        public void RequireOrDie(string[] args)
        {
            // check form post for required values 
            // if not found redirect to errorpage
            var missingFields = new ArrayList();
            foreach (string s in args)
            {
                if (null == Request.Form[s])
                {
                    missingFields.Add(s);
                }
            }
            if (missingFields.Count > 0)
            {
                GoToErrorPage("Required fields missing: " +
                              String.Join(", ", (string[]) missingFields.ToArray(typeof (string))));
            }
        }

        public void AddEnvelopeID(string id)
        {
            if (null == Session[Keys.EnvelopeIds])
            {
                Session[Keys.EnvelopeIds] = id;
            }
            else
            {
                Session[Keys.EnvelopeIds] += "," + id;
            }
        }

        public string[] GetEnvelopeIDs()
        {
            if (null == Session[Keys.EnvelopeIds])
            {
                return new string[0];
            }
            var ids = Session[Keys.EnvelopeIds].ToString();
            return ids.Split(',');
        }

        public bool LoggedIn()
        {
            return (null != Session[Keys.ApiAccountId] &&
                null != Session[Keys.ApiEmail] &&
                null != Session[Keys.ApiPassword] &&
                null != Session[Keys.ApiIkey]);
        }
    }
}