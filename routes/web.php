<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
    //return json_encode(App\Video::Remove(509),JSON_UNESCAPED_UNICODE);
});

Auth::routes();

Route::get('/home', 'HomeController@index')->name('home');
