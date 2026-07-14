/* MagicMirror² config — Example house
 * Copy to: ~/MagicMirror/config/config.js
 */

let config = {
	address: "localhost",
	port: 8080,
	basePath: "/",
	ipWhitelist: ["127.0.0.1", "::ffff:127.0.0.1", "::1"],

	useHttps: false,
	language: "en",
	locale: "en-US",
	logLevel: ["INFO", "LOG", "WARN", "ERROR"],
	timeFormat: 12,
	units: "imperial",
	customCss: "css/custom.css",

	modules: [
		{ module: "alert" },
		{ module: "updatenotification", position: "top_bar" },
		{
			module: "clock",
			position: "top_left",
			config: {
				timeFormat: 12,
				displaySeconds: true,
				showPeriod: true,
				showDate: true,
			},
		},
		{
			module: "MMM-LocalPrayerTime",
			position: "top_left",
			config: {
				lat: 42.4710579,
				lon: -83.0133362,
				timezone: "America/Detroit",
				method: "ISNA",
				asr: "Hanafi",
				timeFormat: 12,
				showTomorrow: false,
				vertical: true,
				highlightCurrent: true,
				notDisplayed: ["sunrise", "sunset", "midnight"],
			},
		},
		{
			module: "weather",
			position: "top_right",
			header: "Weather",
			config: {
				weatherProvider: "openmeteo",
				type: "current",
				lat: 42.4710579,
				lon: -83.0133362,
				degreeLabel: true,
				showHumidity: "none",
				showSun: true,
			},
		},
		{
			module: "MMM-DailyHadith",
			position: "bottom_bar",
			config: {
				showTitle: true,
				showTopic: true,
				showSummary: true,
				showArabic: true,
				showTranslation: true,
				showBangla: true,
				showReference: true,
				showNarrator: true,
				language: "en",
				rotationMode: "daily",
			},
		},
		{
			module: "MMM-DailyDua",
			position: "bottom_bar",
			config: {
				showTitle: true,
				showCategory: true,
				showArabic: true,
				showTransliteration: true,
				showTranslation: true,
				showReference: true,
				showRepeat: true,
				language: "en",
				rotationMode: "interval",
				rotateEveryHours: 3,
				filterByTime: true,
				morningTime: "05:00",
				eveningTime: "16:00",
			},
		},
	],
};

/*************** DO NOT EDIT THE LINE BELOW ***************/
if (typeof module !== "undefined") {
	module.exports = config;
}
