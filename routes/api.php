<?php

use App\Http\Controllers\Api\AttachmentController;
use App\Http\Controllers\Api\DummyDataController;
use App\Http\Controllers\Api\DummyLoginController;
use App\Http\Controllers\Api\SampleController;
use App\Http\Controllers\Api\TestUploadController;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function () {
    Route::post('/auth/login', DummyLoginController::class)
        ->middleware('throttle:5,1')
        ->name('api.v1.auth.login');

    Route::get('/products', [DummyDataController::class, 'products'])
        ->name('api.v1.products.index');

    Route::get('/client/config', [DummyDataController::class, 'clientConfig'])
        ->name('api.v1.client.config');

    Route::get('/categories', [DummyDataController::class, 'categories'])
        ->name('api.v1.categories.index');

    Route::get('/orders', [DummyDataController::class, 'orders'])
        ->name('api.v1.orders.index');

    // Attachments of business records, backed by media-api
    // (see ../media-api/attachment_integration.md). X-Client-Code is mandatory.
    Route::middleware('tenant')->prefix('attachments')->group(function () {
        Route::get('/{entityType}/{entityId}', [AttachmentController::class, 'index'])
            ->name('api.v1.attachments.index');

        Route::post('/{entityType}/{entityId}', [AttachmentController::class, 'store'])
            ->name('api.v1.attachments.store');

        Route::delete('/{attachmentId}', [AttachmentController::class, 'destroy'])
            ->name('api.v1.attachments.destroy');
    });

    // Demo CRUD over the "sample" table: proves the database connection end to end.
    Route::apiResource('sample', SampleController::class)
        ->parameters(['sample' => 'id'])
        ->whereNumber('id');

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

        try {
            DB::connection()->getPdo();
            $database = true;
        } catch (Throwable) {
            $database = false;
        }

        return response()->json([
            'status' => 'ok',
            'service' => 'MyBizGate Client API',
            'version' => '0.1.0',
            'environment' => app()->environment(),
            'deployment' => $deployment,
            'database' => $database,
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
