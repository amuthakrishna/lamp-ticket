<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\Mail;

class SendTestEmail extends Command
{
    protected $signature = 'send:test-email';
    protected $description = 'Send a test email to a specified address';

    public function __construct()
    {
        parent::__construct();
    }

    public function handle()
    {
        $details = [
            'title' => 'Test Email from Laravel',
            'body' => 'This is a test email sent from Laravel using Mailtrap.'
        ];

        Mail::send('emails.test', $details, function ($message) {
            $message->to('your-email@example.com', 'Test User')
                    ->subject('Test Email');
        });

        $this->info('Test email has been sent!');
    }
}

