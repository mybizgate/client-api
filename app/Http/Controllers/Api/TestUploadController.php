<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class TestUploadController extends Controller
{
    public function upload(Request $request)
    {
        $tenant = $request->header('X-Client-Code', 'lzhub');

        abort_unless(
            preg_match('/^[a-z0-9-]+$/', $tenant),
            400,
            'Invalid client code'
        );

        $request->validate([
            'file' => [
                'required',
                'file',
                'image',
                'mimes:jpg,jpeg,png,webp',
                'max:10240',
            ],
        ]);

        $file = $request->file('file');

        $filename = Str::uuid()->toString() . '.webp';
        $directory = "tenants/{$tenant}/products";
        $path = "{$directory}/{$filename}";

        $webpData = $this->convertToWebp(
            $file->getRealPath(),
            1600,
            1600,
            80
        );

        Storage::disk('tenant_uploads')->put($path, $webpData);

        return response()->json([
            'success' => true,
            'tenant' => $tenant,
            'filename' => $filename,
            'path' => $path,
            'format' => 'webp',
            'size_bytes' => strlen($webpData),
            'view_url' => url("/api/v1/test/files/{$tenant}/{$filename}"),
            'download_url' => url("/api/v1/test/files/{$tenant}/{$filename}/download"),
        ], 201);
    }

    public function view(string $tenant, string $filename)
    {
        $this->validatePath($tenant, $filename);

        $path = "tenants/{$tenant}/products/{$filename}";

        abort_unless(
            Storage::disk('tenant_uploads')->exists($path),
            404
        );

        return response()->file(
            Storage::disk('tenant_uploads')->path($path),
            [
                'Content-Type' => 'image/webp',
                'Cache-Control' => 'public, max-age=86400',
            ]
        );
    }

    public function download(string $tenant, string $filename)
    {
        $this->validatePath($tenant, $filename);

        $path = "tenants/{$tenant}/products/{$filename}";

        abort_unless(
            Storage::disk('tenant_uploads')->exists($path),
            404
        );

        return Storage::disk('tenant_uploads')->download($path, $filename);
    }

    private function convertToWebp(
        string $sourcePath,
        int $maxWidth = 1600,
        int $maxHeight = 1600,
        int $quality = 80
    ): string {
        $info = getimagesize($sourcePath);

        abort_unless($info !== false, 422, 'Invalid image');

        [$width, $height] = $info;
        $mime = $info['mime'];

        $source = match ($mime) {
            'image/jpeg' => imagecreatefromjpeg($sourcePath),
            'image/png'  => imagecreatefrompng($sourcePath),
            'image/webp' => imagecreatefromwebp($sourcePath),
            default      => null,
        };

        abort_unless($source !== null, 422, 'Unsupported image format');

        $scale = min(
            $maxWidth / $width,
            $maxHeight / $height,
            1
        );

        $newWidth = (int) round($width * $scale);
        $newHeight = (int) round($height * $scale);

        $destination = imagecreatetruecolor($newWidth, $newHeight);

        imagealphablending($destination, false);
        imagesavealpha($destination, true);

        $transparent = imagecolorallocatealpha(
            $destination,
            0,
            0,
            0,
            127
        );

        imagefilledrectangle(
            $destination,
            0,
            0,
            $newWidth,
            $newHeight,
            $transparent
        );

        imagecopyresampled(
            $destination,
            $source,
            0,
            0,
            0,
            0,
            $newWidth,
            $newHeight,
            $width,
            $height
        );

        ob_start();
        imagewebp($destination, null, $quality);
        $data = ob_get_clean();

        imagedestroy($source);
        imagedestroy($destination);

        abort_unless($data !== false, 500, 'Image conversion failed');

        return $data;
    }

    private function validatePath(string $tenant, string &$filename): void
    {
        abort_unless(
            preg_match('/^[a-z0-9-]+$/', $tenant),
            400,
            'Invalid tenant'
        );

        $filename = basename($filename);

        abort_unless(
            preg_match('/^[A-Za-z0-9._-]+$/', $filename),
            400,
            'Invalid filename'
        );
    }
}
