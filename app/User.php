<?php

namespace App;

use Illuminate\Notifications\Notifiable;
use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Support\Facades\DB;

class User extends Authenticatable
{
    use Notifiable;

    public $timestamps = false;
    protected $table = "User";
    
    protected $fillable = [
        'login', 'email', 'password',
    ];

    protected $hidden = [
        'password', 'remember_token'
    ];

    //GET
    public static function Info(string $Login){
        return DB::select('exec GetUserInfo ?', array($Login));
    }

    public static function List(){
        return DB::select('exec GetUsers');
    }

    public static function Search($Login, $Email, $Role){
        return DB::select('exec SearchUsers ?, ?, ?', array($Login, $Email, $Role));
    }
    
    //PUT
    public static function SaveSecretKey(string $UserEmail, $SecretKey){
        DB::update('exec SaveSecretKey ?, ?', array($UserEmail, $SecretKey));
    }
    
    public static function EditRole(int $Id, string $NewRole){
        DB::update('exec UpdateUserRole ?, ?', array($Id, $NewRole));
    }
    
    public static function Blocking(int $Id, bool $Blocking){
        DB::update('exec BlockingUser ?, ?', array($Id, $Blocking));
    }
    
    //DELETE
    public static function Remove(int $Id){
        DB::delete('exec DeleteUser ?', array($Id));
    }

}
