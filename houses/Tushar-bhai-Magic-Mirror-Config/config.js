/* MagicMirror² Config — Tushar bhai
 * Copy to: ~/MagicMirror/config/config.js
 * Fill in OpenWeather api keys and WiFi details on the Pi (do not commit secrets).
 *
 * Based on: https://docs.magicmirror.builders/configuration/introduction.html
 */
let config = {
	address: "localhost",
	port: 8080,
	basePath: "/",
	ipWhitelist: ["127.0.0.1", "::ffff:127.0.0.1", "::1"],

	useHttps: false,
	httpsPrivateKey: "",
	httpsCertificate: "",

	language: "en",
	locale: "en-US",
	logLevel: ["INFO", "LOG", "WARN", "ERROR"],
	timeFormat: 12,
	units: "imperial",

	modules: [
		{
			module: "alert",
		},
		{
			module: "updatenotification",
			position: "top_bar",
		},
		{
			module: "clock",
			position: "top_left",
			config: {
				displaySeconds: true,
				zoom: 1.0,
			},
		},
		{
			module: "MMM-DynamicWeather",
			position: "fullscreen_above",
			config: {
				// See https://github.com/scottcl88/MMM-DynamicWeather
				api_key: "", // OpenWeather API key
				lat: 42.4710579,
				lon: -83.0133362,
				locationID: "5014051",
				hideFog: true,
				hideSun: true,
				hideMoon: true,
				effects: [
					{
						month: "",
						day: "",
						year: "",
						images: [],
						direction: "down",
					},
				],
			},
		},
		{
			module: "currentislamicdate",
			position: "bottom_right",
		},
		{
			module: "MMM-DailyDua",
			position: "bottom_bar",
			config: {
				language: "bn",
				rotationMode: "interval",
				rotateEveryHours: 3,
				filterByTime: true,
				morningTime: "05:00",
				eveningTime: "16:00",
				strictMorningEvening: true,
				showTitle: true,
				showCategory: true,
				showArabic: true,
				showTransliteration: true,
				showTranslation: true,
				showReference: true,
				showRepeat: true,
			},
		},
		{
			module: "MMM-DailyHadith",
			position: "bottom_bar",
			config: {
				showTitle: true,
				showTopic: false,
				showSummary: false,
				showArabic: false,
				showTranslation: true,
				showBangla: false,
				showReference: true,
				showNarrator: false,
				language: "en",
				maxTextChars: 0,
				rotationMode: "daily",
				updateInterval: 60 * 60 * 1000,
			},
		},
		{
			module: "MMM-QuranAyah",
			position: "bottom_bar",
			config: {
				apiVersion: "1.0",
				showArabic: true,
				showTranslation: true,
				surahArabicName: false,
				translationLang: "en.yusufali",
				updateInterval: 300000,
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
				notDisplayed: [],
			},
		},
		{
			module: "calendar_monthly",
			position: "top_left",
			config: {},
		},
		{
			module: "MMM-Worldclock",
			position: "top_left",
			config: {
				timeFormat: "hh:mm A",
				style: "top",
				offsetTimezone: null,
				clocks: [
					{
						title: "LONDON",
						timezone: "Europe/London",
						flag: "gb",
					},
					{
						title: "DHAKA",
						timezone: "Asia/Dhaka",
						flag: "bd",
					},
					{
						title: "MACCA",
						timezone: "Asia/Riyadh",
						flag: "sa",
					},
					{
						title: "GAZA",
						timezone: "Asia/Gaza",
						flag: "ps",
					},
				],
			},
		},
		{
			module: "MMM-WiFiPassword",
			position: "top_left",
			config: {
				header: "",
				network: "YOUR_WIFI_SSID", // set on the Pi — do not commit real SSID/password
				password: "YOUR_WIFI_PASSWORD",
				showPassword: false,
				showAuthType: false,
				showNetwork: true,
				qrSize: 88,
				layoutVertical: true,
				colorDark: "#ffffff",
				colorLight: "#000000",
			},
		},
		{
			module: "MMM-OpenmapWeather",
			position: "top_right",
			header: "Current Weather",
			config: {
				locationID: "4988400",
				appid: "", // openweathermap.org API key
				colorIcon: true,
			},
		},
		{
			module: "MMM-OpenWeatherMapForecast",
			header: "Weather",
			position: "top_right",
			classes: "default everyone",
			disabled: false,
			config: {
				apikey: "", // openweathermap.org API key
				latitude: "42.4961493",
				longitude: "-82.9926113",
				iconset: "6fa",
				concise: false,
				forecastLayout: "tiled",
				maxHourliesToShow: 2,
				showCurrentConditions: false,
				maxDailiesToShow: 6,
				showPrecipitation: false,
				showWind: false,
				showHourlyForecast: true,
				showSummary: false,
				showExtraCurrentConditions: false,
			},
		},
	],
};

/*************** DO NOT EDIT THE LINE BELOW ***************/
if (typeof module !== "undefined") {
	module.exports = config;
}
