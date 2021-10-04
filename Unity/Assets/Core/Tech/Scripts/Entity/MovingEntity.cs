using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

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

    public Image ElementSprite;
    public Text TextPV;
    public BulletElement CurrentElement = BulletElement.Neutral;

    public int radius = 1;

    private bool button = false;
    public float reloadTimer = 0.5f;
    private bool canShoot = true;
    public AudioSource shootingSound;
    public AudioSource breaking, fire, stone, water, wind;

    public bool cheat;

    public const int maxLife = 12;
    public int currentLife = maxLife;

    public float damageCooldown = 0.75f;
    private bool onDamageCooldown = false;
    private WorldManager Manager;
    private Sprite[] ElementSprites;

    // Start is called before the first frame update
    public void Init(HexTilemap map, WorldManager worldManager, Sprite[] elementSprites)
    {
        this.map = map;
        Rgbd = this.GetComponent<Rigidbody>();
        Anim = GetComponentInChildren<Animator>();
        ElementSprites = elementSprites;
        ElementSprite.color = new Color(0, 0, 0, 0);
        TextPV.text = currentLife+"/8";
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
                ElementSprite.sprite = ElementSprites[(int)BulletElement.Fire];
                ElementSprite.color = new Color(100, 100, 100, 100);
            }
            if (Input.GetKeyDown("joystick button 1"))
            {
                CurrentElement = BulletElement.Wind;
                ElementSprite.sprite = ElementSprites[(int)BulletElement.Wind];
                ElementSprite.color = new Color(100, 100, 100, 100);
            }
            if (Input.GetKeyDown("joystick button 2"))
            {
                CurrentElement = BulletElement.Earth;
                ElementSprite.sprite = ElementSprites[(int)BulletElement.Earth];
                ElementSprite.color = new Color(100, 100, 100, 100);
            }
            if (Input.GetKeyDown("joystick button 3"))
            {
                CurrentElement = BulletElement.Water;
                ElementSprite.sprite = ElementSprites[(int)BulletElement.Water];
                ElementSprite.color = new Color(100, 100, 100, 100);
            }
        }

        button |= Input.GetButtonDown(fire1);
        button |= Input.GetButtonDown(fire2);
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
            ElementSprite.color = new Color(0, 0, 0, 0);
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
        if(onMapDamagingCell)
        {
            Damage(1);
        }
    }

    IEnumerator waitForDamageCooldown()
    {
        yield return new WaitForSeconds(damageCooldown);
        onDamageCooldown = false;
        yield return null;
    }

    internal bool CanPickElement(BulletElement element)
    {
        if (CurrentElement == BulletElement.Neutral)
        {
            CurrentElement = element;
            ElementSprite.color = new Color(100, 100, 100, 100);

            ElementSprite.sprite = ElementSprites[(int)element];
            ElementSprite.color = new Color(100, 100, 100, 100);
            return true;
        }
        return false;
    }


    public void Damage(int amount)
    {
        if(onDamageCooldown) return;
        currentLife -= amount;
        Anim.SetTrigger("Hit");
        TextPV.text = currentLife+"/8";
        if(currentLife <= 0)
        {
            Die();
        } else
        {
            onDamageCooldown = true;
            StartCoroutine("waitForDamageCooldown");
        }
    }

    void Die()
    {
        TextPV.text = "Dead";
        ElementSprite.color = new Color(0,0,0,0);
        this.gameObject.SetActive(false);
        Manager.OnCharacterDie();
    }

    public void PlayBreakingSound(BulletElement element)
    {
        breaking.Play();
        if (element == BulletElement.Fire)
        {
            fire.Play();
        }
        else if (element == BulletElement.Earth)
        {
            stone.Play();
        }
        else if (element == BulletElement.Water)
        {
            water.Play();
        }
        else if (element == BulletElement.Wind)
        {
            wind.Play();
        }
    }
}

