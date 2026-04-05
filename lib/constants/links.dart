const String appBaseUrl = "https://projexhub-v2-backend.onrender.com";
const String loginUrl = "$appBaseUrl/login";
const String registerUrl = "$appBaseUrl/register";
const String changePasswordUrl = "$appBaseUrl/change-password";
const String verificationUrl = "$appBaseUrl/api/users/verify";
const String deleteUserUrl = "$appBaseUrl/api/users/";
const String createProjectUrl = "$appBaseUrl/api/projects";
const String deleteProjectUrl = "$appBaseUrl/api/projects";
const String updateProjectUrl = "$appBaseUrl/api/projects";
const String updateProfileUrl = "$appBaseUrl/api/users/";
const String allProjectsUrl = "$appBaseUrl/api/projects";
const String getProjectsUrl = "$appBaseUrl/api/projects/user/me";
const String getUserApprovedProjectsUrl = "$appBaseUrl/api/projects/user/approved";
const String getProjectByIdUrl = "$appBaseUrl/api/projects";
const String toggleLikeUrl = "$appBaseUrl/api/projects";
const String addCommentUrl = "$appBaseUrl/api/projects";
const String getCommentsUrl = "$appBaseUrl/api/projects";
const String replyUrl = "$appBaseUrl/api/projects";
const String sendFeedbackUrl = "$appBaseUrl/api/feedback/send";
const String topProjectsByCategoryUrl = "$appBaseUrl/api/projects/top/categories";
const String getSummaryAiUrl = "$appBaseUrl/api/ai/project-summary";
const String getChatAiUrl = "$appBaseUrl/api/ai/ask-project-question";
const String getProjectScoreAiUrl = "$appBaseUrl/api/ai/project-score";
const String searchProjectsUrl = "$appBaseUrl/api/projects/search?query=";
const String geminiApiKey = "YOUR_GEMINI_API_KEY";

// Cloudinary
const String cloudinaryCloudName = "YOUR_CLOUDINARY_CLOUD_NAME";
const String cloudinaryUploadPreset = "YOUR_UPLOAD_PRESET"; // your unsigned upload preset name
const String cloudinaryUploadUrl = "https://api.cloudinary.com/v1_1/$cloudinaryCloudName/auto/upload";