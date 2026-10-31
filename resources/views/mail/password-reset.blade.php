<!doctype html>
<html lang="ms">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Tetapan semula kata laluan</title>
</head>
<body style="margin:0;padding:24px 12px;background:#f4f5f1;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Helvetica,Arial,sans-serif;color:#1f2a1f;">
  <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="max-width:520px;margin:0 auto;background:#ffffff;border:1px solid #e3e6dc;border-radius:14px;">
    <tr>
      <td style="padding:28px 24px 8px;">
        <p style="margin:0 0 6px;font-size:11px;letter-spacing:.08em;text-transform:uppercase;color:#62785f;font-weight:700;">{{ $site->site_name }}</p>
        <h1 style="margin:0;font-size:22px;line-height:1.3;">Tetapan semula kata laluan</h1>
      </td>
    </tr>
    <tr>
      <td style="padding:8px 24px;font-size:15px;line-height:1.7;">
        <p style="margin:0 0 12px;">Hai {{ $user->name }},</p>
        <p style="margin:0 0 12px;">Kami menerima permintaan untuk menetapkan semula kata laluan akaun pengurusan anda ({{ $user->email }}). Tekan butang di bawah untuk memilih kata laluan baharu.</p>
      </td>
    </tr>
    <tr>
      <td style="padding:8px 24px 16px;">
        <a href="{{ $url }}" style="display:inline-block;background:#1d5c3a;color:#ffffff;text-decoration:none;font-weight:700;font-size:15px;padding:13px 22px;border-radius:10px;">Tetapkan kata laluan baharu</a>
      </td>
    </tr>
    <tr>
      <td style="padding:0 24px 24px;font-size:13px;line-height:1.7;color:#5b665b;">
        <p style="margin:0 0 10px;">Pautan ini sah selama {{ $ttlMinutes }} minit dan hanya boleh digunakan sekali. Jika anda tidak membuat permintaan ini, abaikan e-mel ini; kata laluan anda tidak berubah.</p>
        <p style="margin:0;">Jika butang tidak berfungsi, salin pautan ini ke pelayar anda:<br><a href="{{ $url }}" style="color:#1d5c3a;word-break:break-all;">{{ $url }}</a></p>
      </td>
    </tr>
  </table>
  <p style="max-width:520px;margin:16px auto 0;font-size:11px;color:#8a938a;text-align:center;">Dihantar oleh MyBizGate bagi pihak {{ $site->site_name }}.</p>
</body>
</html>
