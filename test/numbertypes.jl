using Test, LinearMaps, LinearAlgebra, Quaternions

@testset "noncommutative number type" begin
    x = Quaternion.(rand(10), rand(10), rand(10), rand(10))
    v = rand(10)
    A = Quaternion.(rand(10,10), rand(10,10), rand(10,10), rand(10,10))
    γ = Quaternion.(rand(4)...) # "Number"
    α = UniformScaling(γ)
    β = UniformScaling(Quaternion.(rand(4)...))
    L = LinearMap(A)
    @test Array(L) == A
    @test Array(L') == A'
    @test Array(transpose(L)) == transpose(A)
    @test Array(α * L) == α * A
    @test Array(L * α) == A * α
    @test Array(α * L) == α * A
    @test Array(L * α ) == A * α
    @test Array(α * L') == α * A'
    @test Array((α * L')') ≈ (α * A')' ≈ A * conj(α)
    @test L * x ≈ A * x
    @test L' * x ≈ A' * x
    @test α * (L * x) ≈ α * (A * x)
    @test α * L * x ≈ α * A * x
    @test 3L * x ≈ 3A * x
    @test 3L' * x ≈ 3A' * x
    @test α * (3L * x) ≈ α * (3A * x)
    @test α * 3L * x ≈ α * 3A * x
    @test (α * L') * x ≈ (α * A') * x
    @test (α * L')' * x ≈ (α * A')' * x
    @test (α * L')' * v ≈ (α * A')' * v
    @test Array(@inferred adjoint(α * L * β)) ≈ conj(β) * A' * conj(α)
    @test Array(@inferred transpose(α * L * β)) ≈ β * transpose(A) * α
    J = LinearMap(α, 10)
    @test (β * J) * x ≈ LinearMap(β*α, 10) * x ≈ β*α*x
    @test (J * β) * x ≈ LinearMap(α*β, 10) * x ≈ α*β*x
    M = β.λ * (γ * L * L)
    @test M == β * (γ * L * L)
    @test length(M.maps) == 3
    @test M.maps[end].λ == β.λ * γ
    @test γ * (β * L * L) == γ * (β.λ * L * L) == α * (β.λ * L * L) == α * (β * L * L)
    @test length(M.maps) == 3
    @test M.maps[end].λ == β.λ * γ
    M = (L * L * γ) * β.λ
    @test M == (L * L * γ) * β == (L * L * α) * β == (L * L * α) * β.λ
    @test length(M.maps) == 3
    @test M.maps[1].λ == γ*β.λ

    # exercise non-RealOrComplex scalar operations
    @test Array(γ * (L'*L)) ≈ γ * (A'*A) # CompositeMap
    @test Array((L'*L) * γ) ≈ (A'*A) * γ
    @test Array(-L) == -A
    @test Array(γ \ L) ≈ γ \ A
    @test Array(L / γ) ≈ A / γ
end

@testset "nonassociative number type" begin
    x = Octonion.(rand(10), rand(10), rand(10), rand(10),rand(10), rand(10), rand(10), rand(10))
    v = rand(10)
    A = Octonion.(rand(10,10), rand(10,10), rand(10,10), rand(10,10),rand(10,10), rand(10,10), rand(10,10), rand(10,10))
    α = UniformScaling(Octonion.(rand(8)...))
    β = UniformScaling(Octonion.(rand(8)...))
    L = LinearMap(A)
    @test Array(L) == A
    @test Array(α * L) == α * A
    @test Array(L * α) == A * α
    @test Array(α * L) == α * A
    @test Array(L * α) == A * α
    @test (α * L')' * v ≈ (α * A')' * v
end
