# Deployment Guide

1. In the root directory of the project, run `composer i` to install dependencies.
2. Provide the database credentials in `./configs/database.json`.
3. Import the SQL script from `./run.sql` into your database.
4. Specify the API entry in `./configs/api.json`. For local deployment, it should be the project name  + "/" (e.g. `racebets/` for `http://localhost/racebets/customers/`). For server deployment, leave it empty (e.g. `""` for `http://141.8.59.138/customers/`).
5. Remove the full group by rule for the `customers/report` route with the following command: `SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''))`.

# Project Overview

The project is structured following the simple MVC pattern and uses OOP principles, along with the `composer` library for validation. The project includes the following components:

1. The main file `http.php` is the starting point for the project.
2. The `api/` directory contains domain components, each with the following 4 files:
   - `router.php` maps incoming requests to the corresponding controller's method.
   - `controller.php` communicates with the DTO and model files.
   - `dto.php` validates request parameters using the `rakit/validator` library.
   - `model.php` connects the controller to the database.
3. Configuration files in JSON format are stored in the `configs/` directory and are automatically converted to PHP constants.
4. Core modules such as the CORS fixer script, database, response, and router classes are located in the `modules/` directory.