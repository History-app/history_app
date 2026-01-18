import * as functions from "firebase-functions";

export const PACKAGE_NAME = process.env.APP_PACKAGE_NAME!;
export const ANDROID_PACKAGE_NAME = process.env.ANDROID_PACKAGE_NAME!;

// export const PUBLIC_KEY = functions.config().iap.public_key;
// export const RECEIPT_VERIFICATION_PASSWORD_FOR_IOS =
//   functions.config().iap.receipt_verification_password_for_ios;
// export const CLIENT_EMAIL_ANDROID = functions.config().iap.client_email_android;
// export const PRIVATE_KEY_ANDROID = functions
//   .config()
//   .iap.private_key_android.replace(/\\n/g, "\n");

// export const MAILCHIMP_API = functions.config().mailchimp.api;
// export const MAILCHIMP_AUDIENCE = functions.config().mailchimp.audience;

// const sendgridConfig = functions.config().sendgrid;
// export const SG_EXPORT_CSV = sendgridConfig.export_csv_api_key;
// export const SG_AUTH_EMAIL = sendgridConfig.auth_email_api_key;

// const reportMailConfig = functions.config().reportmail;
// export const REPORTMAIL_BASIC_USERNAME = reportMailConfig.basic_username;
// export const REPORTMAIL_BASIC_PASSWORD = reportMailConfig.basic_password;
// export const REPORTMAIL_PUBLIC_KEY = reportMailConfig.public_key;

// export const DATABASE_URL = functions.config().project.database_url;

// export const OPENAI_API_KEY_STG = functions.config().openai.api_key_stg;
// export const OPENAI_API_KEY_PROD = functions.config().openai.api_key_prod;

export const appsflyerConfig = {
  branded_domain: process.env.AF_BRANDED_DOMAIN,
  onelink_path: process.env.AF_ONELINK_PATH,
};
export const AF_BRANDED_DOMAIN = appsflyerConfig?.branded_domain;
// export const AF_ONELINK = appsflyerConfig?.onelink;
export const AF_ONELINK_PATH = appsflyerConfig?.onelink_path;
