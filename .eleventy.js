const avatarExceptions = require("./_data/avatarFileMap.json");

const shortcodes = {
	avatar: function(filename, linkUrl, text = "") {
		if(!filename) {
			return '<span class="avatar"></span>';
		}

		let twitterName;
		if( filename.endsWith(".jpg") || filename.endsWith(".png") ) {
			twitterName = filename.substr(0, -4);
		} else {
			twitterName = filename;
			filename += ".jpg";
		}
		if( avatarExceptions[twitterName] ) {
			filename = avatarExceptions[twitterName];
		}

		return (linkUrl ? `<a href="${linkUrl}">` : "") +
			`<img src="/img/${filename}" class="avatar" alt="@${twitterName} Twitter Photo" loading="lazy">` +
			text +
			(linkUrl ? `</a>` : "");
	}
};

module.exports = function(eleventyConfig) {
	eleventyConfig.addPassthroughCopy("img");
	eleventyConfig.addPassthroughCopy("css");

	eleventyConfig.addShortcode("avatar", shortcodes.avatar);
};