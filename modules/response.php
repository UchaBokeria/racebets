<?php

class Response {

    public function error($msg = 'Bad Request', $code = 400, $status=false)
    {
        !$status && header("HTTP/1.1 $code $msg");
        die(json_encode(['code' => $code, 'success' => $status, 'report' => $msg, 'result' => null]));
    }

    public function json($data = false, $msg = 'Successful Response', $status=true, $code = 200)
    {
        $msg = !$status ? 'Successful Response' : $msg;
        !$status && header("HTTP/1.1 $code $msg");
        die(json_encode(['code' => $code, 'success' => $status, 'report' => $msg, 'result' => $data]));
    }

    public function print($print)
    {
        die($print);
    }

}