<?php

use App\Http\Controllers\Api\DummyLoginController;
use App\Http\Controllers\Api\TestUploadController;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function () {
    Route::post('/auth/login', DummyLoginController::class)
        ->middleware('throttle:5,1')
        ->name('api.v1.auth.login');

    Route::get('/health', function () {
        $deployment = null;
        $deploymentFile = base_path('bootstrap/deployment.json');

        if (is_readable($deploymentFile)) {
            $contents = file_get_contents($deploymentFile);
            $decoded = $contents === false ? null : json_decode($contents, true);

            if (is_array($decoded)
                && isset($decoded['commit'], $decoded['deployed_at'])
                && is_string($decoded['commit'])
                && is_string($decoded['deployed_at'])) {
                $deployment = [
                    'commit' => $decoded['commit'],
                    'deployed_at' => $decoded['deployed_at'],
                ];
            }
        }

        return response()->json([
            'status' => 'ok',
            'service' => 'MyBizGate Client API',
            'version' => '0.1.0',
            'environment' => app()->environment(),
            'deployment' => $deployment,
            'database' => false,
            'timestamp' => now()->toIso8601String(),
        ]);
    });

    Route::get('/info', function () {
        return response()->json([
            'name' => 'MyBizGate Client API',
            'api_version' => 'v1',
            'framework' => 'Laravel',
            'laravel_version' => app()->version(),
        ]);
    });

    Route::post(
        '/test/upload',
        [TestUploadController::class, 'upload']
    );

    Route::get(
        '/test/files/{tenant}/{filename}',
        [TestUploadController::class, 'view']
    );

    Route::get(
        '/test/files/{tenant}/{filename}/download',
        [TestUploadController::class, 'download']
    );

});
