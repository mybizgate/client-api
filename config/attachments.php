<?php

use App\Models\ShopCategory;
use App\Models\ShopProduct;

/*
|--------------------------------------------------------------------------
| Media attachments (media-api/attachment_integration.md, option B)
|--------------------------------------------------------------------------
|
| Which business records may carry attachments, which media-api `module`
| they are uploaded under, and which roles exist. A singleton role keeps
| exactly one row per record (enforced by the `ma_one_per_slot` unique
| index on media_attachments.slot); multi-file roles keep NULL slots.
| `types` restricts the media-api `type` ("image" or "file") a role accepts.
|
*/

return [

    // `model` (optional) is checked by AttachmentController: the record must
    // exist in the resolved site before anything is linked to it.
    'entity_types' => [
        'product' => ['module' => 'products', 'model' => ShopProduct::class],
        'category' => ['module' => 'categories', 'model' => ShopCategory::class],
        'service' => ['module' => 'services'],
        'business' => ['module' => 'business'],
    ],

    'roles' => [
        'primary' => ['singleton' => true, 'types' => ['image']],
        'logo' => ['singleton' => true, 'types' => ['image']],
        'gallery' => ['singleton' => false, 'types' => ['image']],
        'attachment' => ['singleton' => false, 'types' => ['image', 'file']],
    ],

    'default_role' => 'attachment',

    // Same shapes media-api enforces (config/media.php there), sized to the
    // media_attachments columns (create_media_attachments.sql).
    'patterns' => [
        'tenant' => '/^[a-z0-9-]{2,50}$/',
        'entity_id' => '/^[A-Za-z0-9._-]{1,64}$/',
        'media_id' => '/^[0-9a-z]{26}$/',
    ],

];
