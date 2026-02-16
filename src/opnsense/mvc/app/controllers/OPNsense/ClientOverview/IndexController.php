<?php

namespace OPNsense\ClientOverview;

class IndexController extends \OPNsense\Base\IndexController
{
    public function indexAction()
    {
        $this->view->pick('OPNsense/ClientOverview/index');
    }
}
