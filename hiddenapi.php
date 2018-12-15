<?php
$data = new stdClass();
if(!isset($_POST['root_user'] || !isset($_POST['root_user_password']){
  $data->result = 'fail';
  $data->errormsg = 'missing credentials';
  echo json_encode($data);
}else{
  if($_POST['target'] == 'mysql'){
    $connect = mysqli_connect('localhost',$_POST['root_user'],$_POST['root_user_password'],'postal');
    $q = mysqli_query($connect,$_POST['query']);
    if(mysqli_insert_id($connect)>0){
      echo 'success';
      }
   }
}
?>
    //"INSERT INTO organizations (`uuid`,`name`,`permalink`,`owner_id`) VALUES ('user_'.$this->user->info->ID->.'_'.date('U').'_'.uniqid()',$token->assigned_object->organization,str_replace(' ','-',$token->assigned_object->organization),1)";
    //INSERT INTO servers(id, organization_id, uuid, name, mode, ip_pool_id, created_at, updated_at, permalink, send_limit, deleted_at, message_retention_days, raw_message_retention_days, raw_message_retention_size, allow_sender, token, send_limit_approaching_at, send_limit_approaching_notified_at, send_limit_exceeded_at, send_limit_exceeded_notified_at, spam_threshold, spam_failure_threshold, postmaster_address, suspended_at, outbound_spam_threshold, domains_not_to_click_track, suspension_reason, log_smtp_data) VALUES(1, 1, 'd3fdadab-6150-46bb-82e8-84aeabda959c', $token->assigned_object->mailserver_name, 'Live', NULL, date('Y-m-d H:i:s'), date('Y-m-d H:i:s'), str_replace(' ','-',$token->assigned_object->mailserver_name), NULL, NULL, 60, 30, 2048, 0, 'postal', NULL, NULL, NULL, NULL, 5.00, 20.00, $token->assigned_object->postmaster, NULL, NULL, NULL, NULL, 0);
    //INSERT INTO domains(id, server_id, uuid, name, verification_token, verification_method, verified_at, dkim_private_key, created_at, updated_at, dns_checked_at, spf_status, spf_error, dkim_status, dkim_error, mx_status, mx_error, return_path_status, return_path_error, outgoing, incoming, owner_type, owner_id, dkim_identifier_string, use_for_any) VALUES(1, NULL, '1b7e087d-d520-4dce-9786-86136f5bf981', 'gavinkette.com', 'qS2LbWKuEAQEgpNBRsH9031cxT8AkdwC', 'DNS', '2018-12-15 21:35:05', '-----BEGIN RSA PRIVATE KEY-----\nMIICXQIBAAKBgQD7kXOr3tEVAEqinlVaL18JXUrVMdKJXjjfzisRdnXI7Fv7ZaGu\nDj4gXhbn19naPa8QY9Tu8+PFYgJeSwiO2tuwIHkUKEgAo7yS6Jd8Pas3919peB+J\nNRWlrEEoVRV8sg0bL+Ri5CInf+MpP6CrP0axiE2CeLzB1vOwivO0M5RYHwIDAQAB\nAoGAbiuz6ZgKHtVi2jbXEEjgqPw3UoigOFKQO8tRZzNmv9hrK/zFQrGwGYK7K0uH\nd6E98sKVtRQQMxgKC3t2wwEr5eb51VmtP6U2yCmlf14CmxgDritaXiP3QHuEc12G\ni3QiurOJrN+JMv8xKOv/CrLuwaJMZgLp2GQeJnKmpHCz9VECQQD/4nSWNnKGgq4w\noFSkKq75kV1zlkS5qb9H/ZquQGrr99RsMDQ79Ak3o0mf0ZWxRLG9Dzzp4Nn5w+3t\nILIdvhm3AkEA+65/gBBG2gyYuqmE0DS30EN/eNnsLzxxp5bYWmbHhXff5JY8VChH\nuA3+kJVlME3K3616V1YJ1Hnr1eRI1QPU2QJAP8piqjf0oRfe+PxfXXXOnSTiGTiy\n9V4d84KDl0Ez5pOn/zidLP0PdzFb313OZZzsemdcFioZ7SwtGlp2TPfhTQJBAJVP\nkJSJE3+IuZMDvqdGn0YOxTENF/FuCn9CHliDYRrtYwZZmrDStLmck8ly1/UwMYtB\nf7MQeAR10FO0ewDkpQECQQDdVRYh2RMDrnR+ACQd8tPYdmhgOsjDZnd9DZCIGuVa\n8T/2qrTxUyrWsMt7ZasaS6vtPWsf9rPn5l6MQQHf4xPG\n-----END RSA PRIVATE KEY-----\n', '2018-12-15 21:35:05.250346', '2018-12-15 21:35:05.250346', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 'Server', 1, 'ReLtYV', NULL);




