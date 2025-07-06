CREATE TABLE "USERS"(
    "id" UUID NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "phone" VARCHAR(255) NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "role" VARCHAR(255) CHECK
        ("role" IN('admin', 'client', 'rider')) NOT NULL DEFAULT 'client'
);
ALTER TABLE
    "USERS" ADD PRIMARY KEY("id");
CREATE TABLE "MENU_CATEGORIES"(
    "id" UUID NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "description" VARCHAR(255) NOT NULL
);
ALTER TABLE
    "MENU_CATEGORIES" ADD PRIMARY KEY("id");
CREATE TABLE "MENU_ITEMS"(
    "id" UUID NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "price" INTEGER NOT NULL,
    "image" VARCHAR(255) NOT NULL,
    "description" VARCHAR(255) NOT NULL,
    "menu_category_id" UUID NOT NULL
);
ALTER TABLE
    "MENU_ITEMS" ADD PRIMARY KEY("id");
CREATE TABLE "ORDERS"(
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "total_price" INTEGER NOT NULL,
    "delivery_address" VARCHAR(255) NOT NULL,
    "status" VARCHAR(255) CHECK
        (
            "status" IN(
                'pending',
                'confirmed',
                'preparing',
                'dispatched',
                'delivered',
                'cancelled'
            )
        ) NOT NULL DEFAULT 'pending',
        "delivery_lat" FLOAT(53) NOT NULL,
        "delivery_lng" FLOAT(53) NOT NULL,
        "rider_id" UUID NULL
);
ALTER TABLE
    "ORDERS" ADD PRIMARY KEY("id");
CREATE TABLE "ORDER_ITEMS"(
    "id" UUID NOT NULL,
    "order_id" UUID NOT NULL,
    "menu_item_id" UUID NOT NULL,
    "quantity" INTEGER NOT NULL,
    "price" INTEGER NOT NULL
);
ALTER TABLE
    "ORDER_ITEMS" ADD PRIMARY KEY("id");
CREATE TABLE "PAYMENT"(
    "id" UUID NOT NULL,
    "order_id" UUID NOT NULL,
    "amount" INTEGER NOT NULL,
    "payment_method" VARCHAR(255) CHECK
        (
            "payment_method" IN('mpesa', 'cash')
        ) NOT NULL DEFAULT 'cash',
        "status" VARCHAR(255)
    CHECK
        (
            "status" IN('paid', 'pending', 'failed')
        ) NOT NULL
);
ALTER TABLE
    "PAYMENT" ADD PRIMARY KEY("id");
CREATE TABLE "RIDER_PROFILE"(
    "user_id" UUID NOT NULL,
    "transport_mode" VARCHAR(255) CHECK
        (
            "transport_mode" IN('foot', 'bicycle', 'motorbike')
        ) NOT NULL,
        "license_plate" VARCHAR(255) NULL,
        "available" BOOLEAN NOT NULL DEFAULT '1',
        "current_lat" FLOAT(53) NOT NULL,
        "current_lng" FLOAT(53) NOT NULL
);
ALTER TABLE
    "RIDER_PROFILE" ADD PRIMARY KEY("user_id");
CREATE TABLE "SHOP_DETAILS"(
    "id" UUID NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "address" TEXT NOT NULL,
    "latitude" FLOAT(53) NOT NULL,
    "longitude" FLOAT(53) NOT NULL,
    "delivery_radius_km" FLOAT(53) NOT NULL,
    "contact_phone" VARCHAR(255) NOT NULL,
    "open_time" TIME(0) WITHOUT TIME ZONE NOT NULL,
    "close_time" TIME(0) WITHOUT TIME ZONE NOT NULL
);
ALTER TABLE
    "SHOP_DETAILS" ADD PRIMARY KEY("id");
ALTER TABLE
    "ORDERS" ADD CONSTRAINT "orders_id_foreign" FOREIGN KEY("id") REFERENCES "USERS"("id");
ALTER TABLE
    "ORDER_ITEMS" ADD CONSTRAINT "order_items_menu_item_id_foreign" FOREIGN KEY("menu_item_id") REFERENCES "MENU_ITEMS"("id");
ALTER TABLE
    "MENU_ITEMS" ADD CONSTRAINT "menu_items_menu_category_id_foreign" FOREIGN KEY("menu_category_id") REFERENCES "MENU_CATEGORIES"("id");
ALTER TABLE
    "RIDER_PROFILE" ADD CONSTRAINT "rider_profile_user_id_foreign" FOREIGN KEY("user_id") REFERENCES "USERS"("id");
ALTER TABLE
    "ORDERS" ADD CONSTRAINT "orders_id_foreign" FOREIGN KEY("id") REFERENCES "SHOP_DETAILS"("id");
ALTER TABLE
    "ORDER_ITEMS" ADD CONSTRAINT "order_items_order_id_foreign" FOREIGN KEY("order_id") REFERENCES "ORDERS"("id");
ALTER TABLE
    "PAYMENT" ADD CONSTRAINT "payment_order_id_foreign" FOREIGN KEY("order_id") REFERENCES "ORDERS"("id");