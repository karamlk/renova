<?php

namespace Tests\Feature;

use App\Models\ReconstructionRequest;
use App\Models\ReconstructionRequestImage;
use Database\Seeders\RoleSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Tests\TestCase;

class ReconstructionRequestWorkflowTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(RoleSeeder::class);
        Storage::fake('public');
    }

    // ─────────────────────────────────────────────────
    // Creating a request
    // ─────────────────────────────────────────────────

    public function test_user_can_create_reconstruction_request_with_images(): void
    {
        $user = $this->createUser();

        $response = $this->withHeaders($this->authHeaders($user))
            ->postJson('/api/reconstruction-requests', [
                'title'       => 'Home Renovation',
                'description' => 'Need full renovation',
                'location'    => 'Damascus',
                'type'        => 'finishing',
                'images'      => [
                    UploadedFile::fake()->image('photo1.jpg'),
                    UploadedFile::fake()->image('photo2.jpg'),
                ],
            ]);

        $response->assertStatus(201);

        $this->assertDatabaseHas('reconstruction_requests', [
            'user_id'  => $user->id,
            'title'    => 'Home Renovation',
            'status'   => 'open',
        ]);

        // Images were stored
        $this->assertDatabaseCount('reconstruction_request_images', 2);
    }

    public function test_reconstruction_request_requires_title(): void
    {
        $user = $this->createUser();

        $this->withHeaders($this->authHeaders($user))
            ->postJson('/api/reconstruction-requests', [
                'description' => 'No title here',
                'location'    => 'Damascus',
                'type'        => 'finishing',
                'images'      => [UploadedFile::fake()->image('photo.jpg')],
            ])
            ->assertStatus(422)
            ->assertJsonValidationErrors(['title']);
    }

    public function test_reconstruction_request_requires_valid_type(): void
    {
        $user = $this->createUser();

        $this->withHeaders($this->authHeaders($user))
            ->postJson('/api/reconstruction-requests', [
                'title'       => 'Test',
                'description' => 'Test',
                'location'    => 'Damascus',
                'type'        => 'invalid_type',
                'images'      => [UploadedFile::fake()->image('photo.jpg')],
            ])
            ->assertStatus(422)
            ->assertJsonValidationErrors(['type']);
    }

    public function test_reconstruction_request_requires_at_least_one_image(): void
    {
        $user = $this->createUser();

        $this->withHeaders($this->authHeaders($user))
            ->postJson('/api/reconstruction-requests', [
                'title'       => 'Test',
                'description' => 'Test',
                'location'    => 'Damascus',
                'type'        => 'finishing',
            ])
            ->assertStatus(422)
            ->assertJsonValidationErrors(['images']);
    }

    // TODOTest: make middleware that won't let any role other than the user to make a reconstructionRequest
    public function test_contractor_cannot_create_reconstruction_request(): void
    {
        $contractor = $this->createContractor();

        $this->withHeaders($this->authHeaders($contractor))
            ->postJson('/api/reconstruction-requests', [
                'title'       => 'Test',
                'description' => 'Test',
                'location'    => 'Damascus',
                'type'        => 'finishing',
                'images'      => [UploadedFile::fake()->image('photo.jpg')],
            ])
            ->assertStatus(403);
    }

    public function test_unauthenticated_user_cannot_create_request(): void
    {
        $this->postJson('/api/reconstruction-requests', [
            'title'       => 'Test',
            'description' => 'Test',
            'location'    => 'Damascus',
            'type'        => 'finishing',
        ])->assertStatus(401);
    }

    // ─────────────────────────────────────────────────
    // Listing requests
    // ─────────────────────────────────────────────────

    public function test_contractor_can_see_all_open_requests(): void
    {
        $contractor = $this->createContractor();
        $user       = $this->createUser();

        ReconstructionRequest::factory()->count(3)->create([
            'user_id' => $user->id,
            'status'  => 'open',
        ]);

        // Closed request should not appear
        ReconstructionRequest::factory()->create([
            'user_id' => $user->id,
            'status'  => 'closed',
        ]);

        $response = $this->withHeaders($this->authHeaders($contractor))
            ->getJson('/api/reconstruction-requests');

        $response->assertStatus(200);

        // Only open ones returned
        foreach ($response->json('data') as $item) {
            $this->assertEquals('open', $item['status']);
        }
    }

    public function test_contractor_can_filter_requests_by_location(): void
    {
        $contractor = $this->createContractor();
        $user       = $this->createUser();

        ReconstructionRequest::factory()->create([
            'user_id'  => $user->id,
            'location' => 'Damascus',
            'status'   => 'open',
        ]);

        ReconstructionRequest::factory()->create([
            'user_id'  => $user->id,
            'location' => 'Aleppo',
            'status'   => 'open',
        ]);

        $response = $this->withHeaders($this->authHeaders($contractor))
            ->getJson('/api/reconstruction-requests?location=Damascus');

        $response->assertStatus(200);

        foreach ($response->json('data') as $item) {
            $this->assertEquals('Damascus', $item['location']);
        }
    }

    public function test_contractor_can_filter_requests_by_type(): void
    {
        $contractor = $this->createContractor();
        $user       = $this->createUser();

        ReconstructionRequest::factory()->create([
            'user_id' => $user->id,
            'type'    => 'finishing',
            'status'  => 'open',
        ]);

        ReconstructionRequest::factory()->create([
            'user_id' => $user->id,
            'type'    => 'construction',
            'status'  => 'open',
        ]);

        $response = $this->withHeaders($this->authHeaders($contractor))
            ->getJson('/api/reconstruction-requests?type=finishing');

        $response->assertStatus(200);

        foreach ($response->json('data') as $item) {
            $this->assertEquals('finishing', $item['type']);
        }
    }

    // ─────────────────────────────────────────────────
    // Showing a single request
    // ─────────────────────────────────────────────────

    public function test_authenticated_user_can_view_any_request(): void
    {
        $user    = $this->createUser();
        $request = ReconstructionRequest::factory()->create(['user_id' => $user->id]);

        $contractor = $this->createContractor();

        $this->withHeaders($this->authHeaders($contractor))
            ->getJson("/api/reconstruction-requests/{$request->id}")
            ->assertStatus(200)
            ->assertJsonPath('data.id', $request->id);
    }

    public function test_show_returns_404_for_nonexistent_request(): void
    {
        $user = $this->createUser();

        $this->withHeaders($this->authHeaders($user))
            ->getJson('/api/reconstruction-requests/99999')
            ->assertStatus(404);
    }

    // ─────────────────────────────────────────────────
    // Updating a request
    // ─────────────────────────────────────────────────

    public function test_user_can_update_own_request(): void
    {
        $user    = $this->createUser();
        $request = ReconstructionRequest::factory()->create([
            'user_id' => $user->id,
            'title'   => 'Old Title',
        ]);

        $this->withHeaders($this->authHeaders($user))
            ->postJson("/api/reconstruction-requests/{$request->id}", [
                'title'       => 'Updated Title',
                'description' => 'Updated description',
                'location'    => 'Aleppo',
                'type'        => 'construction',
            ])
            ->assertStatus(200)
            ->assertJsonPath('data.title', 'Updated Title');
    }

    public function test_user_cannot_update_another_users_request(): void
    {
        $owner   = $this->createUser();
        $other   = $this->createUser();
        $request = ReconstructionRequest::factory()->create(['user_id' => $owner->id]);

        $this->withHeaders($this->authHeaders($other))
            ->postJson("/api/reconstruction-requests/{$request->id}", [
                'title'       => 'Hacked Title',
                'description' => 'Hacked',
                'location'    => 'Damascus',
                'type'        => 'finishing',
            ])
            ->assertStatus(403);
    }

    public function test_contractor_cannot_update_reconstruction_request(): void
    {
        $user       = $this->createUser();
        $contractor = $this->createContractor();
        $request    = ReconstructionRequest::factory()->create(['user_id' => $user->id]);

        $this->withHeaders($this->authHeaders($contractor))
            ->postJson("/api/reconstruction-requests/{$request->id}", [
                'title'       => 'Hacked',
                'description' => 'Hacked',
                'location'    => 'Damascus',
                'type'        => 'finishing',
            ])
            ->assertStatus(403);
    }

    // ─────────────────────────────────────────────────
    // Deleting a request
    // ─────────────────────────────────────────────────

    //TodoTest: soft delete to exist
    public function test_user_can_delete_own_request(): void
    {
        $user    = $this->createUser();
        $request = ReconstructionRequest::factory()->create(['user_id' => $user->id]);

        $this->withHeaders($this->authHeaders($user))
            ->deleteJson("/api/reconstruction-requests/{$request->id}")
            ->assertStatus(200);

        $this->assertSoftDeleted('reconstruction_requests', ['id' => $request->id]);
    }

    public function test_user_cannot_delete_another_users_request(): void
    {
        $owner   = $this->createUser();
        $other   = $this->createUser();
        $request = ReconstructionRequest::factory()->create(['user_id' => $owner->id]);

        $this->withHeaders($this->authHeaders($other))
            ->deleteJson("/api/reconstruction-requests/{$request->id}")
            ->assertStatus(403);
    }

    //TODOTest: make sure the flow
    public function test_user_cannot_delete_closed_request(): void
    {
        $user    = $this->createUser();
        $request = ReconstructionRequest::factory()->create([
            'user_id' => $user->id,
            'status'  => 'closed',
        ]);

        $this->withHeaders($this->authHeaders($user))
            ->deleteJson("/api/reconstruction-requests/{$request->id}")
            ->assertStatus(422);
    }

    public function test_contractor_cannot_delete_reconstruction_request(): void
    {
        $user       = $this->createUser();
        $contractor = $this->createContractor();
        $request    = ReconstructionRequest::factory()->create(['user_id' => $user->id]);

        $this->withHeaders($this->authHeaders($contractor))
            ->deleteJson("/api/reconstruction-requests/{$request->id}")
            ->assertStatus(403);
    }
}
