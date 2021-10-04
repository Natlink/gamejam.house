using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class MovingEntity : MonoBehaviour
{
    private const float RADIANS_TO_DEGREE = 180 / Mathf.PI;
    public String moveX = "Player1MoveX";
    public String moveZ = "Player1MoveZ";
    public float deadZone = 0.1f;

    public String aimX = "Player1AimX";
    public String aimZ = "Player1AimZ";
    public float deadZoneAim = 0.15f;

    public String fire1 = "Player1Fire1";
    public String fire2 = "Player1Fire2";
    public String fire3 = "Player1Fire3";

    public float SpeedNormal = 10;
    public float SpeedIce = 25.0f;
    public float SpeedLiquid = 3.0f;

    public float InertiaNormal = 0.5f;
    public float InertiaIce = 0.95f;

    public Animator Anim;
    public Rigidbody Rgbd;
    public HexTilemap map;
    public Bullet bullet;
    public float angle = 0;

    public TextMeshProUGUI TextElement;
    public TextMeshProUGUI TextPV;
    public BulletElement CurrentElement = BulletElement.Neutral;

    public int radius = 1;

    private bool button = false;
    public float reloadTimer = 0.5f;
    private bool canShoot = true;
    public AudioSource shootingSound;

    public bool cheat;

    public const int maxLife = 12;
    public int currentLife = maxLife;

    public float mapDamageCooldown = 1.0f;
    private bool onMapDamageCooldown = false;
    private WorldManager Manager;

    // Start is called before the first frame update
    public void Init(HexTilemap map, WorldManager worldManager)
    {
        this.map = map;
        Rgbd = this.GetComponent<Rigidbody>();
        Anim = GetComponentInChildren<Animator>();
        TextElement.text = CurrentElement + "";
        TextPV.text = "Life: " + currentLife;
        Manager = worldManager;
    }

    // Update is called once per frame
    public void FixedUpdate()
    {
        HexCell cell = map.GetCell(Rgbd.position);
        CellElement cellElem = cell != null ? cell.Prop.CurrentElement : CellElement.Neutral;
        Move(cellElem);
        Aim();
        Shoot();
        MapDamage(cellElem);
    }

    private void Update()
    {
        if (cheat)
        {
            if (Input.GetKeyDown("joystick button 0"))
            {
                CurrentElement = BulletElement.Fire;
                TextElement.text = CurrentElement + "";
            }
            if (Input.GetKeyDown("joystick button 1"))
            {
                CurrentElement = BulletElement.Wind;
                TextElement.text = CurrentElement + "";
            }
            if (Input.GetKeyDown("joystick button 2"))
            {
                CurrentElement = BulletElement.Earth;
                TextElement.text = CurrentElement + "";
            }
            if (Input.GetKeyDown("joystick button 3"))
            {
                CurrentElement = BulletElement.Water;
                TextElement.text = CurrentElement + "";
            }
        }

        button |= Input.GetButtonDown(fire1);
    }

    void Move(CellElement cellElem)
    {
        bool onIce = cellElem == CellElement.Ice;
        bool inLiquid = (cellElem == CellElement.Lava || cellElem == CellElement.Wet);

        float speed = onIce ? SpeedIce : inLiquid ? SpeedLiquid : SpeedNormal;
        float xDirection = Input.GetAxis(moveX) * speed;
        float zDirection = Input.GetAxis(moveZ) * speed;

        Anim.SetBool("Running", !(xDirection == 0 && zDirection == 0));
        bool move = deadZone * deadZone < (new Vector2(xDirection, zDirection)).sqrMagnitude;

        xDirection = move ? xDirection : 0;
        zDirection = move ? zDirection : 0;

        Vector3 prevVelocity = Rgbd.velocity;
        Vector3 targetVelocity = new Vector3(xDirection, prevVelocity.y, zDirection);
        float Inertia = (onIce ? InertiaIce : InertiaNormal);
        Rgbd.velocity = (prevVelocity * Inertia) + (targetVelocity * (1 - Inertia));
    }

    void Aim()
    {
        float xAim = Input.GetAxis(aimX);
        float zAim = Input.GetAxis(aimZ);
        Vector2 aim = new Vector2(xAim, zAim);
        if (deadZoneAim * deadZoneAim < aim.sqrMagnitude)
        {
            angle = Mathf.Atan2(xAim, zAim);
            this.transform.rotation = Quaternion.Euler(0, angle * 180 / Mathf.PI, 0);
        }
    }

    void Shoot()
    {
        if (button && canShoot && CurrentElement != BulletElement.Neutral)
        {
            var b = Instantiate<Bullet>(bullet);
            b.Init(this, radius, new Vector3(Mathf.Sin(angle), 0, Mathf.Cos(angle)), CurrentElement, map);
            canShoot = false;
            CurrentElement = BulletElement.Neutral;
            TextElement.text = CurrentElement + "";
            StartCoroutine("Reload");
            shootingSound.Play();
        }
        button = false;
    }

    IEnumerator Reload()
    {
        yield return new WaitForSeconds(reloadTimer);
        canShoot = true;
        yield return null;
    }

    void MapDamage(CellElement cellElem)
    {
        bool onMapDamagingCell = cellElem == CellElement.Flamme | cellElem == CellElement.Lava;
        if(onMapDamagingCell && !onMapDamageCooldown)
        {
            Damage(1);
            if (currentLife > 0)
            {
                onMapDamageCooldown = true;
                StartCoroutine("MapDamageCooldown");
            }
        }
    }

    IEnumerator MapDamageCooldown()
    {
        yield return new WaitForSeconds(mapDamageCooldown);
        onMapDamageCooldown = false;
        yield return null;
    }

    internal bool CanPickElement(BulletElement element)
    {
        if (CurrentElement == BulletElement.Neutral)
        {
            CurrentElement = element;
            TextElement.text = CurrentElement + "";
            return true;
        }
        return false;
    }


    public void Damage(int amount)
    {
        currentLife -= amount;
        Anim.SetTrigger("Hit");
        TextPV.text = "Life: " + currentLife;
        if(currentLife <= 0)
        {
            Die();
        }
    }

    void Die()
    {
        TextPV.text = "Dead";
        TextElement.text = "";
        this.gameObject.SetActive(false);
        Manager.OnCharacterDie();
    }
}

