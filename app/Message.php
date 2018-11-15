<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class Message extends Model
{
    protected $table = "Message";
    public $timestamps = false;
    
    //GET
    public static function List(int $Limit){
        return DB::select('exec GetMessages ?', array($Limit));
    }

    public static function Search(int $Limit, $UserName, $UserEmail, $DateFrom, $DateTo, $AdminLogin, $AdminEmail){
        return DB::select('exec SearchMessages ?, ?, ?, ?, ?, ?, ?',
        array($Limit, $UserName, $UserEmail, $DateFrom, $DateTo, $AdminLogin, $AdminEmail));
    }

    //POST
    public static function Add(string $Name, string $Email, string $Text){
        DB::insert('exec AddMessage ?, ?, ?', array($Name, $Email, $Text));
    }
    
    //PUT
    public static function Edit(int $Id, string $NewText){
        DB::update('exec UpdateMessage ?, ?', array($Id, $NewText));
    }
    
    //DELETE
    public static function Remove(int $Id){
        DB::delete('exec DeleteMessage ?', array($Id));
    }

}
