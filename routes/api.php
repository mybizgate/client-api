<?php

use App\Http\Controllers\Api\AttachmentController;
use App\Http\Controllers\Api\SampleController;
use App\Http\Controllers\Api\Shop\AuthController;
use App\Http\Controllers\Api\Shop\CategoryController;
use App\Http\Controllers\Api\Shop\ClientConfigController;
use App\Http\Controllers\Api\Shop\CustomerProfileController;
use App\Http\Controllers\Api\Shop\Manage\CategoryController as ManageCategoryController;
use App\Http\Controllers\Api\Shop\Manage\DiscountTierController;
use App\Http\Controllers\Api\Shop\Manage\OrderController as ManageOrderController;
use App\Http\Controllers\Api\Shop\Manage\PaymentMethodController;
use App\Http\Controllers\Api\Shop\Manage\ProductController as ManageProductController;
use App\Http\Controllers\Api\Shop\Manage\SettingsController;
use App\Http\Controllers\Api\Shop\OrderController;
use App\Http\Controllers\Api\Shop\PasswordResetController;
use App\Http\Controllers\Api\Shop\ProductController;
use App\Http\Controllers\Api\TestUploadController;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function () {
    // ---- Shop domain (clients/client-lzhub/docs/shop/API_CONTRACT.md) ----
    // `site` resolves X-Client-Code → clients → sites (404 unknown, 403 inactive).
    Route::middleware('site')->group(function () {
        Route::post('/auth/login', [AuthController::class, 'login'])
            ->middleware('throttle:5,1')
            ->name('api.v1.auth.login');
        Route::post('/auth/forgot-password', [PasswordResetController::class, 'forgot'])
            ->middleware('throttle:password-reset-request')
            ->name('api.v1.auth.forgot-password');
        Route::post('/auth/reset-password', [PasswordResetController::class, 'reset'])
            ->middleware('throttle:password-reset-attempt')
            ->name('api.v1.auth.reset-password');

        Route::middleware(['auth:sanctum', 'site.staff'])->group(function () {
            Route::post('/auth/logout', [AuthController::class, 'logout'])->name('api.v1.auth.logout');
            Route::get('/auth/me', [AuthController::class, 'me'])->name('api.v1.auth.me');
        });

        // Public catalogue
        Route::get('/client/config', ClientConfigController::class)->name('api.v1.client.config');
        Route::get('/categories', [CategoryController::class, 'index'])->name('api.v1.categories.index');
        Route::get('/products', [ProductController::class, 'index'])->name('api.v1.products.index');
        Route::get('/products/{slug}', [ProductController::class, 'show'])->name('api.v1.products.show');

        // Customer (guest token; the first write issues one)
        Route::middleware('shop.customer')->group(function () {
            Route::get('/customer/profile', [CustomerProfileController::class, 'show'])->name('api.v1.customer.profile.show');
            Route::put('/customer/profile', [CustomerProfileController::class, 'update'])->name('api.v1.customer.profile.update');
            Route::get('/orders', [OrderController::class, 'index'])->name('api.v1.orders.index');
            Route::post('/orders', [OrderController::class, 'store'])->name('api.v1.orders.store');
            Route::get('/orders/{reference}', [OrderController::class, 'show'])->name('api.v1.orders.show');
            Route::patch('/orders/{reference}/status', [OrderController::class, 'updateStatus'])->name('api.v1.orders.status');
        });

        // Management (owner/staff Sanctum token of the same site)
        Route::middleware(['auth:sanctum', 'site.staff'])->prefix('manage')->name('api.v1.manage.')->group(function () {
            Route::get('/products', [ManageProductController::class, 'index'])->name('products.index');
            Route::post('/products', [ManageProductController::class, 'store'])->name('products.store');
            Route::get('/products/{id}', [ManageProductController::class, 'show'])->whereNumber('id')->name('products.show');
            Route::put('/products/{id}', [ManageProductController::class, 'update'])->whereNumber('id')->name('products.update');
            Route::delete('/products/{id}', [ManageProductController::class, 'destroy'])->whereNumber('id')->name('products.destroy');
            Route::post('/products/{id}/inventory', [ManageProductController::class, 'inventory'])->whereNumber('id')->name('products.inventory');

            Route::get('/categories', [ManageCategoryController::class, 'index'])->name('categories.index');
            Route::post('/categories', [ManageCategoryController::class, 'store'])->name('categories.store');
            Route::put('/categories/{id}', [ManageCategoryController::class, 'update'])->whereNumber('id')->name('categories.update');
            Route::delete('/categories/{id}', [ManageCategoryController::class, 'destroy'])->whereNumber('id')->name('categories.destroy');

            Route::get('/orders', [ManageOrderController::class, 'index'])->name('orders.index');
            Route::get('/orders/{reference}', [ManageOrderController::class, 'show'])->name('orders.show');
            Route::patch('/orders/{reference}/status', [ManageOrderController::class, 'updateStatus'])->name('orders.status');

            Route::middleware('site.owner')->prefix('shop')->group(function () {
                Route::get('/settings', [SettingsController::class, 'show'])->name('settings.show');
                Route::put('/settings', [SettingsController::class, 'update'])->name('settings.update');

                Route::get('/discount-tiers', [DiscountTierController::class, 'index'])->name('tiers.index');
                Route::post('/discount-tiers', [DiscountTierController::class, 'store'])->name('tiers.store');
                Route::put('/discount-tiers/{id}', [DiscountTierController::class, 'update'])->whereNumber('id')->name('tiers.update');
                Route::delete('/discount-tiers/{id}', [DiscountTierController::class, 'destroy'])->whereNumber('id')->name('tiers.destroy');

                Route::get('/payment-methods', [PaymentMethodController::class, 'index'])->name('payment-methods.index');
                Route::post('/payment-methods', [PaymentMethodController::class, 'store'])->name('payment-methods.store');
                Route::put('/payment-methods/{id}', [PaymentMethodController::class, 'update'])->whereNumber('id')->name('payment-methods.update');
                Route::delete('/payment-methods/{id}', [PaymentMethodController::class, 'destroy'])->whereNumber('id')->name('payment-methods.destroy');
            });
        });

        // Attachments of business records, backed by media-api
        // (see ../media-api/attachment_integration.md). Staff of the site only.
        Route::middleware(['auth:sanctum', 'site.staff'])->prefix('attachments')->group(function () {
            Route::get('/{entityType}/{entityId}', [AttachmentController::class, 'index'])
                ->name('api.v1.attachments.index');

            Route::post('/{entityType}/{entityId}', [AttachmentController::class, 'store'])
                ->name('api.v1.attachments.store');

            Route::delete('/{attachmentId}', [AttachmentController::class, 'destroy'])
                ->name('api.v1.attachments.destroy');
        });
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
