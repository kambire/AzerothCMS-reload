var Massmail = {
    testSmtp: function() {
        var button = $('#test_smtp_btn');
        var originalHtml = button.html();
        
        button.prop('disabled', true).html('<i class="fa fa-spinner fa-spin me-1"></i> Testing...');
        
        var data = {
            massmail_smtp_host: $('input[name="massmail_smtp_host"]').val(),
            massmail_smtp_user: $('input[name="massmail_smtp_user"]').val(),
            massmail_smtp_pass: $('input[name="massmail_smtp_pass"]').val(),
            massmail_smtp_port: $('input[name="massmail_smtp_port"]').val(),
            massmail_smtp_crypto: $('select[name="massmail_smtp_crypto"]').val(),
            csrf_token_name: $.cookie('csrf_cookie_name')
        };
        
        $.post(Config.URL + "massmail/admin/test_smtp", data, function(response) {
            button.prop('disabled', false).html(originalHtml);
            
            try {
                var json = JSON.parse(response);
                if (json.status === 1) {
                    Swal.fire('Success', json.msg, 'success');
                } else {
                    Swal.fire({
                        title: 'SMTP Error',
                        html: '<div class="text-start bg-dark p-2 rounded" style="font-family: monospace; font-size: 12px; overflow-x: auto; color: #ff5555;">' + json.msg + '</div>',
                        icon: 'error',
                        width: '600px'
                    });
                }
            } catch (e) {
                Swal.fire('Error', 'Invalid response from server.', 'error');
                console.log(response);
            }
        });
    }
};
