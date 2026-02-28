var Recovery = {
	timeout: null,
	useCaptcha: false,
	useRecaptcha: false,
	useRecaptcha3: false,

	request: function () {
		console.log("Recovery.request() called");
		var postData = {
			"email": $(".email-input").val(),
			"captcha": $(".captcha-input").val(),
		};

		console.log("Post Data:", postData);

		var fields = [
			"email"
		];

		if (Recovery.useCaptcha) {
			fields.push("captcha");
		}

		if (Recovery.useRecaptcha) {
			postData["recaptcha"] = grecaptcha.getResponse();
		}

		if (Recovery.useRecaptcha3) {
			postData["recaptcha"] = $(".g-recaptcha-response").val();
		}

		clearTimeout(Recovery.timeout);
		Recovery.timeout = setTimeout(function () {
			console.log("Sending POST request to: " + Config.URL + "password_recovery/create_request");
			$.post(Config.URL + "password_recovery/create_request", postData, function (data) {
				console.log("Raw response received:", data);
				try {
					if (typeof data === "string") {
						data = JSON.parse(data);
					}

					if (data["showCaptcha"] === true) {
						$(".captcha-field").removeClass("d-none");
					}

					if (Recovery.useRecaptcha3)
						setCaptchaToken();

					if (data["messages"]["error"]) {
						$(".error-feedback").addClass("invalid-feedback alert-danger d-block").removeClass("d-none alert-success valid-feedback").html(data["messages"]["error"]);
					}
					else if (data["messages"]["success"]) {
						$(".error-feedback").addClass("valid-feedback alert-success d-block").removeClass("d-none alert-danger invalid-feedback").html(data["messages"]["success"]);
						$(".email-input").val('');
					}

				} catch (e) {
					console.error("JSON Parse error:", e);
					alert("Technical error: The server returned an invalid response. Check console for details.");
				}
			}).fail(function (xhr, status, error) {
				console.error("AJAX Error:", status, error);
				alert("Network error: Could not connect to the server. (Status: " + status + ")");
			});
		}, 500);
	},

	reset: function () {
		var postData = {
			"token": $(".token-input").val(),
			"new_password": $(".password-input").val(),
			"csrf_token_name": Config.CSRF,
			"csrf_token": Config.CSRF
		};

		clearTimeout(Recovery.timeout);
		Recovery.timeout = setTimeout(function () {
			$.post(Config.URL + "password_recovery/reset_password", postData, function (data) {
				try {
					data = JSON.parse(data);
					console.log(data);

					if (data["messages"]["error"]) {
						if ($(".password-input").val() != "") {
							$(".error-feedback").addClass("invalid-feedback alert-danger d-block").removeClass("d-none").html(data["messages"]["error"]);
						}
					}
					else if (data["messages"]["success"]) {
						if ($(".password-input").val() != "") {
							$(".error-feedback").addClass("valid-feedback alert-success d-block").removeClass("invalid-feedback alert-danger d-none").html(data["messages"]["success"]);
							$(".password-input, .token-input").val('');
						}
					}

				} catch (e) {
					console.error(e);
					console.log(data);
				}
			});

			console.log(postData);

		}, 500);
	},

	refreshCaptcha: function (ele) {
		$(".captcha-input").val('');
		$(".captcha-input").focus();
		var captchaID = $(ele).data("captcha-id");
		var imgField = $("img#" + captchaID);
		imgField.attr("src", imgField.attr("src") + "&d=" + new Date().getTime());
	}
}