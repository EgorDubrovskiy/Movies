<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class Actor extends Model
{
    protected $table = "Actor";
    public $timestamps = false;//not use created_at and updated_at

    //GET
    public static function List(int $Limit){
        return DB::select('exec GetActors ?', array($Limit));
    }

    public static function Search(int $Limit, $Name, $LastName){
        return DB::select('exec SearchActors ?, ?, ?', array($Limit, $Name, $LastName));
    }

    //POST — создание ресурса
    public static function Add(string $Name, string $LastName){
        DB::insert('exec AddActor ?, ?' array($Name, $LastName));
    }

    //PUT — обновление ресурса
    public static function Edit(int $Id, string $NewName, string $NewLastName){
        DB::update('exec UpdateActor ?, ?, ?', array($Id, $NewName, $NewLastName));
    }

    //DELETE — удаление ресурса
    public static function Remove(int $Id){
        DB::delete('exec DeleteActor ?', array($Id));
    }

}